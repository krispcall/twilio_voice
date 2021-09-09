import 'dart:async';
import 'package:flutter_incall/flutter_incall.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/call_record/CallRecordProvider.dart';
import 'package:voice_example/provider/call_transfer/CallTransferProvider.dart';
import 'package:voice_example/provider/contacts/ContactsProvider.dart';
import 'package:voice_example/repository/CallRecordRepository.dart';
import 'package:voice_example/repository/CallTransferRepository.dart';
import 'package:voice_example/repository/ContactRepository.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/ui/common/dialog/CallOnProgressMoreOptionDialog.dart';
import 'package:voice_example/ui/common/dialog/TransferCallDialog.dart';
import 'package:voice_example/ui/dashboard/DashboardView.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddNotesIntentHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/AddTagIntentHolder.dart';
import 'package:voice_example/viewobject/model/allContact/Tags.dart';
import 'package:voice_example/viewobject/model/notification/NotificationMessage.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

const String tag = "IncomingCallView";

class IncomingCallDialog extends StatefulWidget
{
  const IncomingCallDialog({
    Key key,
    @required this.notificationMessage,
    @required this.onReject,
    @required this.onAccept,
    @required this.onDisconnect,
    @required this.onMute,
    @required this.onHold,
    @required this.sendDigits,
    @required this.onSetSpeakerphoneOn,
    @required this.onRecord,
    @required this.onContactTap,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
  }) : super(key: key);

  final NotificationMessage notificationMessage;
  final Function onReject;
  final Function onAccept;
  final Function onDisconnect;
  final Function onMute;
  final Function onHold;
  final Function(String) sendDigits;
  final Function onSetSpeakerphoneOn;
  final Function(bool) onRecord;
  final Function onContactTap;
  final Function onIncomingTap;
  final Function onOutgoingTap;

  @override
  IncomingCallDialogState createState() => IncomingCallDialogState();
}

class IncomingCallDialogState extends State<IncomingCallDialog> with TickerProviderStateMixin
{
  AnimationController animationController;
  IncallManager inCallManager = IncallManager();

  ValueHolder valueHolder;
  bool isCallAccepted = false, isConnectedToInternet = false;
  bool isRecord = false;
  bool isKeyboardVisible = false;
  bool isMicMuted = false;
  bool isOnHold = false;
  String digits = "";
  bool isSpeakerOn = false;
  String events = Utils.getString('connecting');
  int seconds = 0, minutes = 0;
  String callSid = "";
  String conversationId = "";

  CallRecordProvider callRecordProvider;
  CallRecordRepository callRecordRepository;

  ContactsProvider contactsProvider;
  ContactRepository contactsRepository;

  CallTransferProvider callTransferProvider;
  CallTransferRepository callTransferRepository;

  ///Channel Info
  String channelInfo = "";
  String channelName = "";
  String channelNumber = "";
  String channelFlagUrl = "";
  ///Incoming Contact Info
  String incomingContactId;
  String incomingContactCountry = "";
  String incomingContactAddress = "";
  String incomingContactCompany = "";
  String incomingContactNumber;
  String incomingContactName = "";
  String incomingContactEmail = "";
  String incomingContactPicture;
  bool incomingContactVisibility = false;
  String incomingContactFlagUrl = "";
  List<Tags> incomingContactTagsList = [];

  DateTime loginClickTime;

  @override
  void initState()
  {
    super.initState();
    animationController = AnimationController(duration: Config.animation_duration, vsync: this);
    if (widget.notificationMessage != null)
    {
      incomingContactNumber = widget.notificationMessage.data.twiFrom;
      callSid = widget.notificationMessage.data.twiCallSid;
      if (widget.notificationMessage.data.customParameters != null)
      {
        conversationId = widget.notificationMessage.data.customParameters.conversationId;
        if(widget.notificationMessage.data.customParameters.contactName!= null)
        {
          incomingContactName = widget.notificationMessage.data.customParameters.contactName;
        }
        else
        {
          incomingContactName = Utils.getString("unknown");
        }
        if(widget.notificationMessage.data.channelInfo!=null)
        {
          channelName = widget.notificationMessage.data.channelInfo.name;
          channelNumber = widget.notificationMessage.data.channelInfo.number;
          channelFlagUrl = widget.notificationMessage.data.channelInfo.countryLogo;
        }
      }
      else
      {
        incomingContactName = Utils.getString("unknown");
      }
    }
    else
    {
      incomingContactName = Utils.getString("unknown");
      incomingContactNumber = Utils.getString("unknown");
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) async
    {
      DashboardView.incomingEvent.on().listen((event)
      {
        if(event!=null && event["incomingEvent"]=="incomingRinging")
        {
          if(mounted)
          {
            setState(()
            {
              events = event["state"];
            });
          }
        }
        else if (event != null && event["incomingEvent"] == "incomingConnected")
        {
          if(mounted)
          {
            setState(()
            {
              seconds = event["seconds"];
              minutes = event["minutes"];
              isCallAccepted = event["isConnected"];
              events = event["state"];
              isMicMuted = event["isMicMuted"];
              isOnHold = event["isOnHold"];
              digits = event["digits"];
              isSpeakerOn = event["isSpeakerOn"];
              isRecord = event["isRecord"];
            });
          }
        }
        else if (event != null && event["incomingEvent"] == "incomingReconnecting")
        {
          if(mounted)
          {
            setState(()
            {
              events = event["state"];
            });
          }
        }
        else if (event != null && event["incomingEvent"] == "incomingReconnected")
        {
          if(mounted)
          {
            setState(()
            {
              events = event["state"];
            });
          }
        }
        else if (event != null && event["incomingEvent"] == "incomingCallQualityWarningsChanged")
        {
          if(mounted)
          {
            setState(()
            {
              events = event["state"];
            });
          }
        }
      });
    });

    inCallManager.enableProximitySensor(true);
    inCallManager.onProximity.stream.listen((event)
    {
      if (event)
      {
        inCallManager.turnScreenOff();
      }
      else
      {
        inCallManager.turnScreenOn();
      }
    });
  }

  @override
  void dispose()
  {
    inCallManager.enableProximitySensor(false);
    super.dispose();
  }

  Future<bool> _onWillPop()
  {
    animationController.reverse().then<dynamic>((void data)
      {
        if (!mounted)
        {
          return Future<bool>.value(false);
        }
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
        return Future<bool>.value(true);
      },
    );
    return Future<bool>.value(false);
  }

  @override
  Widget build(BuildContext context)
  {
    callTransferRepository = Provider.of<CallTransferRepository>(context);
    callRecordRepository = Provider.of<CallRecordRepository>(context);
    contactsRepository = Provider.of<ContactRepository>(context);
    animationController.forward();
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: CustomColors.mainColor,
        body: AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: animation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation.value), 0.0),
                child: Container(
                  height: MediaQuery.of(context).size.height.sh,
                  width: MediaQuery.of(context).size.width.sw,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  color: CustomColors.mainColor,
                  alignment: Alignment.center,
                  child: MultiProvider(
                    providers: <SingleChildWidget>[
                      ChangeNotifierProvider<ContactsProvider>(
                          lazy: false,
                          create: (BuildContext context) {
                            this.contactsProvider = ContactsProvider(
                                contactRepository: contactsRepository);
                            contactsProvider.doAllContactApiCall().then((value)
                            {
                              contactsProvider.doSearchContactFromDb(incomingContactNumber).then((value)
                              {
                                if (contactsProvider.contactResponse.data.contactResponse.contactResponseData != null && contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges != null && contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges.length != 0)
                                {
                                  setState(()
                                  {
                                    incomingContactId = contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges[0].contactNode.id;
                                    incomingContactCountry = contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges[0].contactNode.country;
                                    incomingContactAddress = contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges[0].contactNode.address;
                                    incomingContactCompany = contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges[0].contactNode.company;
                                    incomingContactNumber = contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges[0].contactNode.number;
                                    incomingContactName = contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges[0].contactNode.name;
                                    incomingContactEmail = contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges[0].contactNode.email;
                                    incomingContactPicture = contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges[0].contactNode.profilePicture;
                                    incomingContactVisibility = contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges[0].contactNode.visibility;
                                    incomingContactFlagUrl = contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges[0].contactNode.flagUrl;
                                    incomingContactTagsList = contactsProvider.contactResponse.data.contactResponse.contactResponseData.contactEdges[0].contactNode.tags;
                                  });
                                }
                              });
                            });
                            return contactsProvider;
                          }),
                      ChangeNotifierProvider<CallRecordProvider>(
                          lazy: false,
                          create: (BuildContext context) {
                            this.callRecordProvider = CallRecordProvider(
                                callRecordRepository: callRecordRepository);
                            return callRecordProvider;
                          }),
                      ChangeNotifierProvider<CallTransferProvider>(
                          lazy: false,
                          create: (BuildContext context) {
                            this.callTransferProvider = CallTransferProvider(
                              callTransferRepository: callTransferRepository,
                            );
                            return callTransferProvider;
                          }),
                    ],
                    child: Consumer<ContactsProvider>(
                      builder: (BuildContext context, ContactsProvider provider,
                          Widget child) {
                        return SafeArea(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height.sh,
                                width: MediaQuery.of(context).size.width.sw,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space100.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                color: CustomColors.mainColor,
                                alignment: Alignment.center,
                                child: SingleChildScrollView(
                                  reverse: true,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(
                                            Dimens.space0.w,
                                            Dimens.space0.h,
                                            Dimens.space0.w,
                                            Dimens.space0.h),
                                        padding: EdgeInsets.fromLTRB(
                                            Dimens.space0.w,
                                            Dimens.space0.h,
                                            Dimens.space0.w,
                                            Dimens.space0.h),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              padding: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              child: Offstage(
                                                offstage: isKeyboardVisible,
                                                child: RoundedNetworkImageHolder(
                                                  width: Dimens.space100,
                                                  height: Dimens.space100,
                                                  boxFit: BoxFit.cover,
                                                  iconUrl: CustomIcon.icon_profile,
                                                  iconColor: CustomColors
                                                      .callInactiveColor,
                                                  iconSize: Dimens.space85,
                                                  boxDecorationColor:
                                                  CustomColors
                                                      .mainDividerColor,
                                                  outerCorner: Dimens.space42,
                                                  innerCorner: Dimens.space32,
                                                  containerAlignment:
                                                  Alignment.bottomCenter,
                                                  imageUrl: incomingContactPicture!=null?incomingContactPicture:"",
                                                ),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space20.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              padding: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              child: ContactNameWidget(
                                                  contact: incomingContactName != null && incomingContactName.isNotEmpty
                                                      ? incomingContactName
                                                      : Utils.getString(
                                                      "unknown")),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              padding: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    child: Text(
                                                      incomingContactNumber,
                                                      textAlign:
                                                      TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                        color: CustomColors
                                                            .bottomAppBarColor,
                                                        fontWeight:
                                                        FontWeight
                                                            .normal,
                                                        fontFamily: Config
                                                            .manropeMedium,
                                                        fontSize: Dimens
                                                            .space15.sp,
                                                        fontStyle: FontStyle
                                                            .normal,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space6.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    alignment: Alignment.center,
                                                    child:
                                                    RoundedNetworkSvgHolder(
                                                      containerWidth:
                                                      Dimens.space20,
                                                      containerHeight:
                                                      Dimens.space20,
                                                      boxFit: BoxFit.contain,
                                                      imageWidth:
                                                      Dimens.space20,
                                                      imageHeight:
                                                      Dimens.space20,
                                                      imageUrl: Config
                                                          .countryLogoUrl +
                                                          channelFlagUrl,
                                                      outerCorner:
                                                      Dimens.space0,
                                                      innerCorner:
                                                      Dimens.space0,
                                                      iconUrl: CustomIcon
                                                          .icon_person,
                                                      iconColor: CustomColors
                                                          .mainColor,
                                                      iconSize: Dimens.space20,
                                                      boxDecorationColor:
                                                      CustomColors
                                                          .transparent,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    padding:
                                                    EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    alignment: Alignment.center,
                                                    child: LogoWidget(
                                                        isCallAccepted: isCallAccepted,
                                                        events: events
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    padding:
                                                    EdgeInsets.fromLTRB(
                                                        Dimens.space0.w,
                                                        Dimens.space0.h,
                                                        Dimens.space0.w,
                                                        Dimens.space0.h),
                                                    alignment: Alignment.center,
                                                    child: TimerWidget(
                                                        isCallAccepted: isCallAccepted,
                                                        seconds: seconds,
                                                        minutes: minutes,
                                                        isOnHold: isOnHold
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.fromLTRB(
                                            Dimens.space0.w,
                                            Dimens.space35.h,
                                            Dimens.space0.w,
                                            Dimens.space64.h),
                                        padding: EdgeInsets.fromLTRB(
                                            Dimens.space0.w,
                                            Dimens.space0.h,
                                            Dimens.space0.w,
                                            Dimens.space0.h),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            BeforeCallAcceptButtonWidget(
                                              isCallAccepted: isCallAccepted,
                                              onAcceptCall: ()
                                              {
                                                if(isRedundantClick(DateTime.now()))
                                                {
                                                  return;
                                                }
                                                widget.onAccept();
                                              },
                                              onRejectCall: ()
                                              {
                                                widget.onReject();
                                              },
                                            ),
                                            AfterCallAcceptButtonWidget(
                                              isCallAccepted: isCallAccepted,
                                              isSpeakerOn: isSpeakerOn,
                                              isMicMute: isMicMuted,
                                              isRecord: isRecord,
                                              isOnHold: isOnHold,
                                              isKeyboardVisible:
                                              isKeyboardVisible,
                                              digit: digits,
                                              onSetSpeakerphoneOn: ()
                                              {
                                                widget.onSetSpeakerphoneOn();
                                              },
                                              onSetMicrophoneMute: ()
                                              {
                                                widget.onMute();
                                              },
                                              onRecord: ()
                                              {
                                                if (isRecord)
                                                {
                                                  callRecordProvider.callRecord(action: 'STOP', callSid: callSid, direction: 'INBOUND').then((data)
                                                  {
                                                    setState(()
                                                    {
                                                      isRecord = false;
                                                    });
                                                    widget.onRecord(false);
                                                  });
                                                }
                                                else
                                                {
                                                  callRecordProvider.callRecord(action: 'START', callSid: callSid, direction: 'INBOUND').then((data)
                                                  {
                                                    setState(()
                                                    {
                                                      isRecord = true;
                                                    });
                                                    widget.onRecord(true);
                                                  });
                                                }
                                              },
                                              onHold: ()
                                              {
                                                widget.onHold();
                                              },
                                              onKeyboardVisibilityTap: ()
                                              {
                                                if (isKeyboardVisible)
                                                {
                                                  setState(() {
                                                    isKeyboardVisible = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    isKeyboardVisible = true;
                                                  });
                                                }
                                              },
                                              onKeyTap: (value)
                                              {
                                                widget.sendDigits(value);
                                              },
                                              onMoreTap: ()
                                              {
                                                showMoreOptionDialog(
                                                  callTransferProvider: callTransferProvider,
                                                  callerId: contactsProvider.getDefaultChannel() != null && contactsProvider.getDefaultChannel().number != null? contactsProvider.getDefaultChannel().number : '',
                                                  conversationId: conversationId,
                                                );
                                              },
                                              onDisconnectCall: ()
                                              {
                                                widget.onDisconnect();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: Dimens.space28.h,
                                  right: Dimens.space16.w,
                                  left: Dimens.space16.w,
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      padding: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      height: Dimens.space60.h,
                                      width:
                                      MediaQuery.of(context).size.width.sw,
                                      color:
                                      CustomColors.black.withOpacity(0.15),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.fromLTRB(
                                                Dimens.space0.w,
                                                Dimens.space0.h,
                                                Dimens.space0.w,
                                                Dimens.space0.h),
                                            child: Text(
                                              channelName,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                color: CustomColors
                                                    .mainDividerColor,
                                                fontWeight:
                                                FontWeight.normal,
                                                fontFamily:
                                                Config.manropeBold,
                                                fontSize: Dimens.space16.sp,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                child: Text(
                                                  channelNumber,
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                    color: CustomColors
                                                        .mainDividerColor,
                                                    fontWeight:
                                                    FontWeight.normal,
                                                    fontFamily:
                                                    Config.heeboRegular,
                                                    fontSize:
                                                    Dimens.space14.sp,
                                                    fontStyle:
                                                    FontStyle.normal,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    Dimens.space6.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                alignment: Alignment.center,
                                                child: RoundedNetworkSvgHolder(
                                                  containerWidth: Dimens.space16,
                                                  containerHeight: Dimens.space16,
                                                  boxFit: BoxFit.contain,
                                                  imageWidth: Dimens.space16,
                                                  imageHeight: Dimens.space16,
                                                  imageUrl: incomingContactFlagUrl!=null?Config.countryLogoUrl + incomingContactFlagUrl:"",
                                                  outerCorner: Dimens.space0,
                                                  innerCorner: Dimens.space0,
                                                  iconUrl: CustomIcon.icon_person,
                                                  iconColor: CustomColors.mainColor,
                                                  iconSize: Dimens.space16,
                                                  boxDecorationColor: CustomColors.transparent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                  )
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void showMoreOptionDialog({CallTransferProvider callTransferProvider, String callerId, String conversationId}) async
  {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.space16.r),
        ),
        backgroundColor: Colors.transparent,
        builder: (BuildContext context)
        {
          return CallOnProgressMoreOptionDialog(
            onAddTagTap: () async
            {
              Navigator.of(context).pop();
              final dynamic returnData = await Navigator.pushNamed(
                  context,
                  RoutePaths.addNewTag,
                  arguments: AddTagIntentHolder(
                    countryId: incomingContactCountry,
                    address: incomingContactAddress,
                    company: incomingContactCompany,
                    email: incomingContactEmail,
                    visibility: incomingContactVisibility,
                    clientId: incomingContactId,
                    name: incomingContactName,
                    profilePicture: incomingContactPicture,
                    number: incomingContactNumber,
                    countryFlag: incomingContactFlagUrl,
                    tags: incomingContactTagsList,
                    onIncomingTap: ()
                    {
                      widget.onIncomingTap();
                    },
                    onOutgoingTap: ()
                    {
                      widget.onOutgoingTap();
                    },
                  )
              );
              if (returnData != null && returnData['data']!=null && returnData['data'])
              {
                setState(()
                {
                  incomingContactId = returnData['clientId'];
                  contactsProvider.doContactDetailApiCall(incomingContactId);
                });
              }
            },
            onAddNoteTap: () async
            {
              Navigator.of(context).pop();
              final dynamic returnData = await Navigator.pushNamed(
                  context, RoutePaths.notesList,
                  arguments: AddNotesIntentHolder(
                    clientId: incomingContactId,
                    number: contactsProvider.contactDetailResponse.data != null && contactsProvider.contactDetailResponse.data.contactDetailResponseData.contacts != null ? contactsProvider.contactDetailResponse.data.contactDetailResponseData.contacts.number : incomingContactNumber,
                    onIncomingTap: ()
                    {
                      widget.onIncomingTap();
                    },
                    onOutgoingTap: ()
                    {
                      widget.onOutgoingTap();
                    },
                  ),
              );
              if (returnData != null && returnData['data']!=null && returnData['data'])
              {
                setState(()
                {
                  incomingContactId = returnData['clientId'];
                  contactsProvider.doContactDetailApiCall(incomingContactId);
                });
              }
            },
            onTransferCallTap: () async
            {
              Navigator.of(context).pop();
              await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimens.space16.r),
                  ),
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return AnimatedPadding(
                      padding: MediaQuery.of(context).viewInsets,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.decelerate,
                      child: TransferCallDialog(
                        callTransferProvider: callTransferProvider,
                        animationController: animationController,
                        onCancelTap: () {},
                        callerId: callerId,
                        conversationId: conversationId,
                        direction: "Incoming",
                      ),
                    );
                  });
            },
            onContactTap: () async
            {
              widget.onContactTap();
              Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
            },
          );
        });
  }

  bool isRedundantClick(DateTime currentTime)
  {
    if(loginClickTime==null)
    {
      loginClickTime = currentTime;
      return false;
    }
    if(currentTime.difference(loginClickTime).inSeconds<10)
    {
      return true;
    }
    loginClickTime = currentTime;
    return false;
  }
}

class ContactNameWidget extends StatelessWidget {
  const ContactNameWidget({
    Key key,
    @required this.contact,
  }) : super(key: key);

  final String contact;

  @override
  Widget build(BuildContext context) {
    return Text(
      contact != null ? contact : Utils.getString("unknown"),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyText1.copyWith(
        color: CustomColors.white,
        fontStyle: FontStyle.normal,
        fontSize: Dimens.space24.sp,
        fontFamily: Config.manropeBold,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    Key key,
    @required this.isCallAccepted,
    @required this.events,
  }) : super(key: key);

  final bool isCallAccepted;
  final String events;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      alignment: Alignment.center,
      child: Offstage(
        offstage: isCallAccepted,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          child: Text(
            events!=null && events.isNotEmpty?events:Utils.getString("connecting"),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: CustomColors.secondaryColor,
              fontStyle: FontStyle.normal,
              fontSize: Dimens.space14.sp,
              fontFamily: Config.manropeMedium,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  const TimerWidget({
    Key key,
    @required this.isCallAccepted,
    @required this.isOnHold,
    @required this.seconds,
    @required this.minutes,
  }) : super(key: key);

  final bool isCallAccepted, isOnHold;
  final int seconds, minutes;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      alignment: Alignment.center,
      child: Offstage(
        offstage: !isCallAccepted,
        child: Container(
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space12.w, Dimens.space6.h,
              Dimens.space12.w, Dimens.space6.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isOnHold
                ? CustomColors.warningColor
                : CustomColors.callAcceptColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(Dimens.space32.r)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                alignment: Alignment.center,
                child: Text(
                  minutes.toString().padLeft(2, '0'),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: CustomColors.white,
                    fontStyle: FontStyle.normal,
                    fontSize: Dimens.space16.sp,
                    fontFamily: Config.manropeSemiBold,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                alignment: Alignment.center,
                child: Text(
                  ":" + seconds.toString().padLeft(2, '0'),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: CustomColors.white,
                    fontStyle: FontStyle.normal,
                    fontSize: Dimens.space16.sp,
                    fontFamily: Config.manropeSemiBold,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  alignment: Alignment.center,
                  child: Offstage(
                    offstage: !isOnHold,
                    child: Text(
                      " - " + Utils.getString("onHold"),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: CustomColors.white,
                        fontStyle: FontStyle.normal,
                        fontSize: Dimens.space16.sp,
                        fontFamily: Config.manropeSemiBold,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class BeforeCallAcceptButtonWidget extends StatelessWidget {
  const BeforeCallAcceptButtonWidget({
    Key key,
    @required this.isCallAccepted,
    @required this.onAcceptCall,
    @required this.onRejectCall,
  }) : super(key: key);

  final bool isCallAccepted;
  final Function onAcceptCall;
  final Function onRejectCall;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: isCallAccepted,
      child: Container(
        width: MediaQuery.of(context).size.width.w,
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space20.h,
            Dimens.space0.w, Dimens.space0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space70,
                      height: Dimens.space70,
                      boxFit: BoxFit.cover,
                      iconUrl: CustomIcon.icon_call_decline,
                      iconColor: Colors.white,
                      iconSize: Dimens.space32,
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space300,
                      boxDecorationColor: CustomColors.callDeclineColor,
                      imageUrl: "",
                      onTap: ()
                      {
                        onRejectCall();
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space10.h, Dimens.space0.w, Dimens.space0.h),
                    child: Text(
                      Utils.getString('decline'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: CustomColors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                  Dimens.space0.w, Dimens.space0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedNetworkImageHolder(
                      width: Dimens.space70,
                      height: Dimens.space70,
                      boxFit: BoxFit.cover,
                      iconUrl: CustomIcon.icon_call,
                      iconColor: Colors.white,
                      iconSize: Dimens.space32,
                      outerCorner: Dimens.space300,
                      innerCorner: Dimens.space300,
                      boxDecorationColor: CustomColors.callAcceptColor,
                      imageUrl: "",
                      onTap: ()
                      {
                        onAcceptCall();
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space10.h, Dimens.space0.w, Dimens.space0.h),
                    child: Text(
                      Utils.getString('accept'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: CustomColors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: Dimens.space14.sp,
                          fontFamily: Config.heeboRegular,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AfterCallAcceptButtonWidget extends StatelessWidget {
  const AfterCallAcceptButtonWidget({
    Key key,
    @required this.isCallAccepted,
    @required this.isMicMute,
    @required this.isSpeakerOn,
    @required this.isRecord,
    @required this.isOnHold,
    @required this.isKeyboardVisible,
    @required this.onSetMicrophoneMute,
    @required this.onSetSpeakerphoneOn,
    @required this.onDisconnectCall,
    @required this.onRecord,
    @required this.onHold,
    @required this.onKeyboardVisibilityTap,
    @required this.onKeyTap,
    @required this.digit,
    @required this.onMoreTap,
  }) : super(key: key);

  final isCallAccepted,
      isMicMute,
      isSpeakerOn,
      isRecord,
      isOnHold,
      isKeyboardVisible;
  final String digit;
  final Function onSetMicrophoneMute;
  final Function onSetSpeakerphoneOn;
  final Function onDisconnectCall;
  final Function onRecord;
  final Function onHold;
  final Function onKeyboardVisibilityTap;
  final Function onKeyTap;
  final Function onMoreTap;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !isCallAccepted,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: Offstage(
              offstage: isKeyboardVisible,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: RoundedNetworkImageHolder(
                            width: Dimens.space70,
                            height: Dimens.space70,
                            boxFit: BoxFit.cover,
                            iconUrl: isRecord
                                ? CustomIcon.icon_stop
                                : CustomIcon.icon_record,
                            iconColor: isRecord
                                ? CustomColors.callDeclineColor
                                : CustomColors.secondaryColor,
                            iconSize: Dimens.space32,
                            outerCorner: Dimens.space300,
                            innerCorner: Dimens.space300,
                            boxDecorationColor: isRecord
                                ? CustomColors.white
                                : CustomColors.black.withOpacity(0.15),
                            imageUrl: "",
                            onTap: () {
                              onRecord();
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space8.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            isRecord
                                ? Utils.getString("stop")
                                : Utils.getString('record'),
                            textAlign: TextAlign.center,
                            style:
                            Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.mainDividerColor,
                              fontWeight: FontWeight.normal,
                              fontFamily: Config.heeboRegular,
                              fontSize: Dimens.space14.sp,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: RoundedNetworkImageHolder(
                            width: Dimens.space70,
                            height: Dimens.space70,
                            boxFit: BoxFit.cover,
                            iconUrl: isMicMute
                                ? CustomIcon.icon_mic_selected
                                : CustomIcon.icon_mic_unselected,
                            iconColor: isMicMute
                                ? CustomColors.callDeclineColor
                                : CustomColors.secondaryColor,
                            iconSize: Dimens.space32,
                            outerCorner: Dimens.space300,
                            innerCorner: Dimens.space300,
                            boxDecorationColor: isMicMute
                                ? CustomColors.white
                                : CustomColors.black.withOpacity(0.15),
                            imageUrl: "",
                            onTap: () {
                              onSetMicrophoneMute();
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space8.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            isMicMute
                                ? Utils.getString("unMute")
                                : Utils.getString('mute'),
                            textAlign: TextAlign.center,
                            style:
                            Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.mainDividerColor,
                              fontWeight: FontWeight.normal,
                              fontFamily: Config.heeboRegular,
                              fontSize: Dimens.space14.sp,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: RoundedNetworkImageHolder(
                            width: Dimens.space70,
                            height: Dimens.space70,
                            boxFit: BoxFit.cover,
                            iconUrl: CustomIcon.icon_speaker,
                            iconColor: isSpeakerOn
                                ? CustomColors.mainColor
                                : CustomColors.secondaryColor,
                            iconSize: Dimens.space32,
                            outerCorner: Dimens.space300,
                            innerCorner: Dimens.space300,
                            boxDecorationColor: !isSpeakerOn
                                ? CustomColors.black.withOpacity(0.15)
                                : CustomColors.white,
                            imageUrl: "",
                            onTap: () {
                              onSetSpeakerphoneOn();
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space8.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            Utils.getString('speaker'),
                            textAlign: TextAlign.center,
                            style:
                            Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.mainDividerColor,
                              fontWeight: FontWeight.normal,
                              fontFamily: Config.heeboRegular,
                              fontSize: Dimens.space14.sp,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: Offstage(
              offstage: isKeyboardVisible,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space20.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: RoundedNetworkImageHolder(
                              width: Dimens.space70,
                              height: Dimens.space70,
                              boxFit: BoxFit.cover,
                              iconUrl: CustomIcon.icon_hold,
                              iconColor: isOnHold
                                  ? CustomColors.mainColor
                                  : CustomColors.secondaryColor,
                              iconSize: Dimens.space32,
                              outerCorner: Dimens.space300,
                              innerCorner: Dimens.space0,
                              boxDecorationColor: isOnHold
                                  ? CustomColors.white
                                  : CustomColors.black.withOpacity(0.15),
                              imageUrl: "",
                              onTap: () {
                                onHold();
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space8.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: Text(
                              isOnHold
                                  ? Utils.getString("resume")
                                  : Utils.getString('hold'),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                color: CustomColors.mainDividerColor,
                                fontWeight: FontWeight.normal,
                                fontFamily: Config.heeboRegular,
                                fontSize: Dimens.space14.sp,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: RoundedNetworkImageHolder(
                              width: Dimens.space70,
                              height: Dimens.space70,
                              boxFit: BoxFit.cover,
                              iconUrl: CustomIcon.icon_dialer_selected,
                              iconColor: CustomColors.secondaryColor,
                              iconSize: Dimens.space32,
                              outerCorner: Dimens.space300,
                              innerCorner: Dimens.space300,
                              boxDecorationColor:
                              CustomColors.black.withOpacity(0.15),
                              imageUrl: "",
                              onTap: () async {
                                onKeyboardVisibilityTap();
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space8.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: Text(
                              Utils.getString('keypad'),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                color: CustomColors.mainDividerColor,
                                fontWeight: FontWeight.normal,
                                fontFamily: Config.heeboRegular,
                                fontSize: Dimens.space14.sp,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: RoundedNetworkImageHolder(
                              width: Dimens.space70,
                              height: Dimens.space70,
                              boxFit: BoxFit.cover,
                              iconUrl: CustomIcon.icon_more,
                              iconColor: CustomColors.secondaryColor,
                              iconSize: Dimens.space32,
                              outerCorner: Dimens.space300,
                              innerCorner: Dimens.space300,
                              boxDecorationColor:
                              CustomColors.black.withOpacity(0.15),
                              imageUrl: "",
                              onTap: onMoreTap,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space8.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: Text(
                              Utils.getString('more'),
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                color: CustomColors.mainDividerColor,
                                fontWeight: FontWeight.normal,
                                fontFamily: Config.heeboRegular,
                                fontSize: Dimens.space14.sp,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            child: Offstage(
              offstage: !isKeyboardVisible,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    child: Text(
                      digit,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: CustomColors.white,
                        fontFamily: Config.manropeSemiBold,
                        fontWeight: FontWeight.normal,
                        fontSize: Dimens.space24.sp,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space35.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          alignment: Alignment.center,
                          width: Dimens.space70.w,
                          height: Dimens.space70.w,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor:
                              CustomColors.black.withOpacity(0.15),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(Dimens.space100.r),
                              ),
                            ),
                            onPressed: () {
                              onKeyTap("1");
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.center,
                              width: Dimens.space70.w,
                              height: Dimens.space70.w,
                              child: Text(
                                Utils.getString("1"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                    color: CustomColors.white,
                                    fontFamily: Config.manropeSemiBold,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Dimens.space32.sp,
                                    fontStyle: FontStyle.normal,
                                    height: Dimens.space2.h),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          alignment: Alignment.center,
                          width: Dimens.space70.w,
                          height: Dimens.space70.w,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor:
                              CustomColors.black.withOpacity(0.15),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(Dimens.space100.r),
                              ),
                            ),
                            onPressed: () {
                              onKeyTap("2");
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.center,
                              width: Dimens.space70.w,
                              height: Dimens.space70.w,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Utils.getString("2"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space2.h),
                                  ),
                                  Text(
                                    Utils.getString("abc"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space12.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space1.h),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          alignment: Alignment.center,
                          width: Dimens.space70.w,
                          height: Dimens.space70.w,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor:
                              CustomColors.black.withOpacity(0.15),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(Dimens.space100.r),
                              ),
                            ),
                            onPressed: () {
                              onKeyTap("3");
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.center,
                              width: Dimens.space70.w,
                              height: Dimens.space70.w,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Utils.getString("3"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space2.h),
                                  ),
                                  Text(
                                    Utils.getString("def"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space12.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space1.h),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space18.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          alignment: Alignment.center,
                          width: Dimens.space70.w,
                          height: Dimens.space70.w,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor:
                              CustomColors.black.withOpacity(0.15),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(Dimens.space100.r),
                              ),
                            ),
                            onPressed: () {
                              onKeyTap("4");
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.center,
                              width: Dimens.space70.w,
                              height: Dimens.space70.w,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Utils.getString("4"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space2.h),
                                  ),
                                  Text(
                                    Utils.getString("ghi"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space12.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space1.h),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          alignment: Alignment.center,
                          width: Dimens.space70.w,
                          height: Dimens.space70.w,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor:
                              CustomColors.black.withOpacity(0.15),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(Dimens.space100.r),
                              ),
                            ),
                            onPressed: () {
                              onKeyTap("5");
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.center,
                              width: Dimens.space70.w,
                              height: Dimens.space70.w,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Utils.getString("5"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space2.h),
                                  ),
                                  Text(
                                    Utils.getString("jkl"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space12.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space1.h),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          alignment: Alignment.center,
                          width: Dimens.space70.w,
                          height: Dimens.space70.w,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor:
                              CustomColors.black.withOpacity(0.15),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(Dimens.space100.r),
                              ),
                            ),
                            onPressed: () {
                              onKeyTap("6");
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.center,
                              width: Dimens.space70.w,
                              height: Dimens.space70.w,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Utils.getString("6"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space2.h),
                                  ),
                                  Text(
                                    Utils.getString("mno"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space12.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space1.h),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space18.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          alignment: Alignment.center,
                          width: Dimens.space70.w,
                          height: Dimens.space70.w,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor:
                              CustomColors.black.withOpacity(0.15),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(Dimens.space100.r),
                              ),
                            ),
                            onPressed: () {
                              onKeyTap("7");
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.center,
                              width: Dimens.space70.w,
                              height: Dimens.space70.w,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Utils.getString("7"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space2.h),
                                  ),
                                  Text(
                                    Utils.getString("pqr"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space12.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space1.h),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          alignment: Alignment.center,
                          width: Dimens.space70.w,
                          height: Dimens.space70.w,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor:
                              CustomColors.black.withOpacity(0.15),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(Dimens.space100.r),
                              ),
                            ),
                            onPressed: () {
                              onKeyTap("8");
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.center,
                              width: Dimens.space70.w,
                              height: Dimens.space70.w,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Utils.getString("8"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space2.h),
                                  ),
                                  Text(
                                    Utils.getString("stuv"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space12.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space1.h),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          alignment: Alignment.center,
                          width: Dimens.space70.w,
                          height: Dimens.space70.w,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor:
                              CustomColors.black.withOpacity(0.15),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(Dimens.space100.r),
                              ),
                            ),
                            onPressed: () {
                              onKeyTap("9");
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.center,
                              width: Dimens.space70.w,
                              height: Dimens.space70.w,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Utils.getString("9"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space2.h),
                                  ),
                                  Text(
                                    Utils.getString("wxyz"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space12.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space1.h),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space18.h, Dimens.space0.w, Dimens.space0.h),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          alignment: Alignment.center,
                          width: Dimens.space70.w,
                          height: Dimens.space70.w,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor:
                              CustomColors.black.withOpacity(0.15),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(Dimens.space100.r),
                              ),
                            ),
                            onPressed: () {
                              onKeyTap("*");
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.center,
                              width: Dimens.space70.w,
                              height: Dimens.space70.w,
                              child: Text(
                                Utils.getString("*"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                    color: CustomColors.white,
                                    fontFamily: Config.manropeSemiBold,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Dimens.space32.sp,
                                    fontStyle: FontStyle.normal,
                                    height: Dimens.space2.h),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          alignment: Alignment.center,
                          width: Dimens.space70.w,
                          height: Dimens.space70.w,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor:
                              CustomColors.black.withOpacity(0.15),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(Dimens.space100.r),
                              ),
                            ),
                            onPressed: () {
                              onKeyTap("0");
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.center,
                              width: Dimens.space70.w,
                              height: Dimens.space70.w,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Utils.getString("0"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.manropeSemiBold,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space32.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space2.h),
                                  ),
                                  Text(
                                    Utils.getString("+"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                        color: CustomColors.white,
                                        fontFamily: Config.heeboMedium,
                                        fontWeight: FontWeight.normal,
                                        fontSize: Dimens.space16.sp,
                                        fontStyle: FontStyle.normal,
                                        height: Dimens.space1.h),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          alignment: Alignment.center,
                          width: Dimens.space70.w,
                          height: Dimens.space70.w,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor:
                              CustomColors.black.withOpacity(0.15),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(Dimens.space100.r),
                              ),
                            ),
                            onPressed: () {
                              onKeyTap("#");
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              alignment: Alignment.center,
                              width: Dimens.space70.w,
                              height: Dimens.space70.w,
                              child: Text(
                                Utils.getString("#"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                    color: CustomColors.white,
                                    fontFamily: Config.manropeSemiBold,
                                    fontWeight: FontWeight.normal,
                                    fontSize: Dimens.space32.sp,
                                    fontStyle: FontStyle.normal,
                                    height: Dimens.space2.h),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width.w,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space64.h,
                Dimens.space0.w, Dimens.space0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: RoundedNetworkImageHolder(
                            width: Dimens.space70,
                            height: Dimens.space70,
                            boxFit: BoxFit.cover,
                            iconUrl: CustomIcon.icon_call_decline,
                            iconColor: CustomColors.white,
                            iconSize: Dimens.space32,
                            outerCorner: Dimens.space300,
                            innerCorner: Dimens.space300,
                            boxDecorationColor: CustomColors.callDeclineColor,
                            imageUrl: "",
                            onTap: () {
                              onDisconnectCall();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Offstage(
                      offstage: !isKeyboardVisible,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: TextButton(
                              child: Text(
                                Utils.getString('hide'),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                  color: CustomColors.mainDividerColor,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: Config.heeboRegular,
                                  fontSize: Dimens.space14.sp,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                onKeyboardVisibilityTap();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
