import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/provider/call_log/CallLogProvider.dart';
import 'package:voice_example/repository/CallLogRepository.dart';
import 'package:voice_example/ui/call_logs/all/AllCallsLogsView.dart';
import 'package:voice_example/ui/call_logs/missed/AllMissedCallLogsView.dart';
import 'package:voice_example/ui/call_logs/new/AllNewCallLogsView.dart';
import 'package:voice_example/ui/common/CustomImageHolder.dart';
import 'package:voice_example/ui/common/CustomTabWidget.dart';
import 'package:voice_example/ui/common/base/CustomAppBar.dart';
import 'package:voice_example/ui/common/dialog/ContactListNewMessageDialog.dart';
import 'package:voice_example/ui/common/dialog/NavigationSearchDialog.dart';
import 'package:voice_example/ui/dashboard/DashboardView.dart';
import 'package:voice_example/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/holder/intent_holder/MessageDetailIntentHolder.dart';
import 'package:provider/provider.dart';

class CallLogsView extends StatefulWidget {
  const CallLogsView({
    Key key,
    @required this.animationController,
    @required this.onSelectAllCheckBoxToggle,
    @required this.onCallTap,
    @required this.onLeadingTap,
    @required this.onIncomingTap,
    @required this.onOutgoingTap,
    @required this.makeCallWithSid,
  }) : super(key: key);

  final AnimationController animationController;
  final Function(bool) onSelectAllCheckBoxToggle;
  final Function onCallTap;
  final Function onLeadingTap;
  final Function onIncomingTap;
  final Function onOutgoingTap;
  final Function(String, String, String, String, String, String, String, String,
      String, String, String, String) makeCallWithSid;

  @override
  CallLogsViewState createState() => CallLogsViewState();
}

class CallLogsViewState extends State<CallLogsView>
    with TickerProviderStateMixin {
  int selectedIndex = 0;

  CallLogRepository callLogRepository;
  CallLogProvider callLogProvider;
  double screenHeight;
  ValueHolder valueHolder;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      DashboardView.ebTransferData.on().listen((event) {
        if (callLogProvider != null) {
          callLogProvider.getTotalNewCallLogsCount();
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    screenHeight = Utils.getStatusBarHeight(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    callLogRepository = Provider.of<CallLogRepository>(context);
    valueHolder = Provider.of<ValueHolder>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomColors.white,
      body: CustomAppBar<CallLogProvider>(
        elevation: 0,
        centerTitle: false,
        onIncomingTap: () {
          widget.onIncomingTap();
        },
        onOutgoingTap: () {
          widget.onOutgoingTap();
        },
        titleWidget: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: RoundedNetworkSvgHolder(
                  containerWidth: Dimens.space40,
                  containerHeight: Dimens.space40,
                  boxFit: BoxFit.contain,
                  imageWidth: Dimens.space20,
                  imageHeight: Dimens.space20,
                  imageUrl: callLogRepository.getDefaultChannel() != null &&
                          callLogRepository.getDefaultChannel().countryLogo !=
                              null
                      ? Config.countryLogoUrl +
                          callLogRepository.getDefaultChannel().countryLogo
                      : "",
                  outerCorner: Dimens.space300,
                  innerCorner: Dimens.space0,
                  iconUrl: CustomIcon.icon_person,
                  iconColor: CustomColors.mainColor,
                  iconSize: Dimens.space20,
                  boxDecorationColor: CustomColors.mainBackgroundColor,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space12.w,
                          Dimens.space0.h, Dimens.space12.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        callLogRepository.getDefaultChannel() != null &&
                                callLogRepository.getDefaultChannel().name !=
                                    null
                            ? callLogRepository.getDefaultChannel().name
                            : Utils.getString("appName"),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: CustomColors.textPrimaryColor,
                              fontFamily: Config.manropeBold,
                              fontSize: Dimens.space16.sp,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                            ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space12.w,
                          Dimens.space0.h, Dimens.space12.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        FlutterLibphonenumber().formatNumberSync(
                            callLogRepository.getDefaultChannel() != null &&
                                    callLogRepository
                                            .getDefaultChannel()
                                            .number !=
                                        null
                                ? callLogRepository.getDefaultChannel().number
                                : Utils.getString("appName")),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: CustomColors.textTertiaryColor,
                            fontFamily: Config.heeboMedium,
                            fontSize: Dimens.space13.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        leadingWidget: TextButton(
          onPressed: widget.onLeadingTap,
          style: TextButton.styleFrom(
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.center,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: Icon(
                  Icons.menu,
                  color: CustomColors.textSecondaryColor,
                  size: Dimens.space24.w,
                ),
              ),
              Positioned(
                right: Dimens.space22.w,
                bottom: Dimens.space22.w,
                child: Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: RoundedNetworkImageHolder(
                    imageUrl: "",
                    width: Dimens.space10,
                    height: Dimens.space10,
                    boxFit: BoxFit.cover,
                    outerCorner: Dimens.space300,
                    innerCorner: Dimens.space300,
                    iconSize: Dimens.space0,
                    iconColor: CustomColors.callDeclineColor,
                    boxDecorationColor: CustomColors.callDeclineColor,
                    iconUrl: CustomIcon.icon_search,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimens.space16.r),
                  ),
                  backgroundColor: Colors.white,
                  builder: (BuildContext context) {

                    return NavigationSearchDialog(
                      onIncomingTap: () {
                        widget.onIncomingTap();
                      },
                      onOutgoingTap: () {
                        widget.onOutgoingTap();
                      },
                      makeCallWithSid: (channelNumber,
                          channelName,
                          channelSid,
                          channelFlagUrl,
                          outgoingNumber,
                          workspaceSid,
                          memberId,
                          voiceToken,
                          outgoingName,
                          outgoingId,
                          outgoingFlagUrl,
                          outgoingProfilePicture) {
                        widget.makeCallWithSid(
                            channelNumber,
                            channelName,
                            channelSid,
                            channelFlagUrl,
                            outgoingNumber,
                            workspaceSid,
                            memberId,
                            voiceToken,
                            outgoingName,
                            outgoingId,
                            outgoingFlagUrl,
                            outgoingProfilePicture);
                      },
                    );
                  });
            },
            style: TextButton.styleFrom(
              alignment: Alignment.center,
              backgroundColor: CustomColors.transparent,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.fromLTRB(
                  Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.space0.r),
              ),
            ),
            child: RoundedNetworkImageHolder(
              width: Dimens.space20,
              height: Dimens.space20,
              boxFit: BoxFit.cover,
              iconUrl: CustomIcon.icon_search,
              iconColor: CustomColors.textTertiaryColor,
              iconSize: Dimens.space18,
              outerCorner: Dimens.space10,
              innerCorner: Dimens.space10,
              boxDecorationColor: CustomColors.transparent,
              imageUrl: "",
            ),
          ),
        ],
        initProvider: () {
          return CallLogProvider(callLogRepository: callLogRepository);
        },
        onProviderReady: (CallLogProvider provider) {
          provider.getTotalNewCallLogsCount();
          callLogProvider = provider;
        },
        builder:
            (BuildContext context, CallLogProvider provider, Widget child) {
          return DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size(
                  MediaQuery.of(context).size.width,
                  Dimens.space40.h,
                ),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          CustomColors.white,
                          CustomColors.bottomAppBarColor
                        ]),
                  ),
                  child: TabBar(
                    isScrollable: false,
                    indicatorColor: CustomColors.mainColor,
                    labelColor: CustomColors.mainColor,
                    unselectedLabelColor: CustomColors.textTertiaryColor,
                    indicatorWeight: Dimens.space2.w,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                          width: Dimens.space2.h,
                          color: CustomColors.mainColor),
                      insets: EdgeInsets.fromLTRB(Dimens.space16.w,
                          Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
                    ),
                    labelStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: Dimens.space14.sp,
                          fontWeight: FontWeight.normal,
                          color: CustomColors.mainColor,
                          fontFamily: Config.manropeSemiBold,
                          fontStyle: FontStyle.normal,
                        ),
                    unselectedLabelStyle:
                        Theme.of(context).textTheme.bodyText1.copyWith(
                              fontSize: Dimens.space14.sp,
                              fontWeight: FontWeight.normal,
                              color: CustomColors.textTertiaryColor,
                              fontFamily: Config.manropeSemiBold,
                              fontStyle: FontStyle.normal,
                            ),
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    tabs: <Widget>[
                      Tab(
                          child: Container(
                        alignment: Alignment.center,
                        height: Dimens.space40.h,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                            Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: CustomTabWidget(
                          offstage: true,
                          selected: selectedIndex == 0 ? true : false,
                          title: Utils.getString('all'),
                          callLogProvider: callLogProvider,
                        ),
                      )),
                      Tab(
                          child: Container(
                        alignment: Alignment.center,
                        height: Dimens.space40.h,
                        child: CustomTabWidget(
                          offstage: true,
                          selected: selectedIndex == 1 ? true : false,
                          title: Utils.getString('missed'),
                          callLogProvider: callLogProvider,
                        ),
                      )),
                      Tab(
                          child: Container(
                        alignment: Alignment.center,
                        height: Dimens.space40.h,
                        child: CustomTabWidget(
                          offstage: false,
                          selected: selectedIndex == 2 ? true : false,
                          title: Utils.getString('new'),
                          callLogProvider: callLogProvider,
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              backgroundColor: CustomColors.white,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniEndFloat,
              floatingActionButton: Container(
                  height: Dimens.space60.w,
                  width: Dimens.space60.w,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(
                      Dimens.space0.w,
                      Dimens.space0.h,
                      Dimens.space5.w,
                      (Utils.getBottomNotchHeight(context)).h + 10),
                  child: FloatingActionButton(
                    hoverElevation: Dimens.space20.r,
                    splashColor: CustomColors.white,
                    foregroundColor: CustomColors.white,
                    focusColor: CustomColors.white,
                    hoverColor: CustomColors.white,
                    backgroundColor: CustomColors.mainColor,
                    tooltip: Utils.getString("dialer"),
                    elevation: Dimens.space5.r,
                    child: Icon(
                      CustomIcon.icon_call_edit,
                      size: Dimens.space20,
                    ),
                    onPressed: () {
                      showContactDialogForNewMessage();
                    },
                  )),
              body: TabBarView(
                children: [
                  AllCallLogsView(
                    animationController: widget.animationController,
                    onSelectAllCheckBoxToggle: widget.onSelectAllCheckBoxToggle,
                    onCallTap: widget.onCallTap,
                    onStartConversationTap: showContactDialogForNewMessage,
                    onIncomingTap: () {
                      widget.onIncomingTap();
                    },
                    onOutgoingTap: () {
                      widget.onOutgoingTap();
                    },
                    makeCallWithSid: (channelNumber,
                        channelName,
                        channelSid,
                        channelFlagUrl,
                        outgoingNumber,
                        workspaceSid,
                        memberId,
                        voiceToken,
                        outgoingName,
                        outgoingId,
                        outgoingFlagUrl,
                        outgoingProfilePicture) {
                      widget.makeCallWithSid(
                          channelNumber,
                          channelName,
                          channelSid,
                          channelFlagUrl,
                          outgoingNumber,
                          workspaceSid,
                          memberId,
                          voiceToken,
                          outgoingName,
                          outgoingId,
                          outgoingFlagUrl,
                          outgoingProfilePicture);
                    },
                  ),
                  AllMissedCallLogsView(
                    animationController: widget.animationController,
                    onSelectAllCheckBoxToggle: widget.onSelectAllCheckBoxToggle,
                    onCallTap: widget.onCallTap,
                    onStartConversationTap: showContactDialogForNewMessage,
                    onIncomingTap: () {
                      widget.onIncomingTap();
                    },
                    onOutgoingTap: () {
                      widget.onOutgoingTap();
                    },
                    makeCallWithSid: (channelNumber,
                        channelName,
                        channelSid,
                        channelFlagUrl,
                        outgoingNumber,
                        workspaceSid,
                        memberId,
                        voiceToken,
                        outgoingName,
                        outgoingId,
                        outgoingFlagUrl,
                        outgoingProfilePicture) {
                      widget.makeCallWithSid(
                          channelNumber,
                          channelName,
                          channelSid,
                          channelFlagUrl,
                          outgoingNumber,
                          workspaceSid,
                          memberId,
                          voiceToken,
                          outgoingName,
                          outgoingId,
                          outgoingFlagUrl,
                          outgoingProfilePicture);
                    },
                  ),
                  AllNewCallLogsView(
                    animationController: widget.animationController,
                    onSelectAllCheckBoxToggle: widget.onSelectAllCheckBoxToggle,
                    onCallTap: widget.onCallTap,
                    onStartConversationTap: showContactDialogForNewMessage,
                    onIncomingTap: () {
                      widget.onIncomingTap();
                    },
                    onOutgoingTap: () {
                      widget.onOutgoingTap();
                    },
                    makeCallWithSid: (channelNumber,
                        channelName,
                        channelSid,
                        channelFlagUrl,
                        outgoingNumber,
                        workspaceSid,
                        memberId,
                        voiceToken,
                        outgoingName,
                        outgoingId,
                        outgoingFlagUrl,
                        outgoingProfilePicture) {
                      widget.makeCallWithSid(
                          channelNumber,
                          channelName,
                          channelSid,
                          channelFlagUrl,
                          outgoingNumber,
                          workspaceSid,
                          memberId,
                          voiceToken,
                          outgoingName,
                          outgoingId,
                          outgoingFlagUrl,
                          outgoingProfilePicture);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showContactDialogForNewMessage() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.space10.r),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return ContactListNewMessageDialog(
            statusBarHeight: screenHeight,
            animationController: widget.animationController,
            onMessageSent: (selectedContact) async {
              final dynamic returnData =
                  await Navigator.pushNamed(context, RoutePaths.messageDetail,
                      arguments: MessageDetailIntentHolder(
                        clientName: selectedContact.contactNode.name,
                        clientPhoneNumber: selectedContact.contactNode.number,
                        clientProfilePicture:
                            selectedContact.contactNode.profilePicture,
                        countryId: selectedContact.contactNode.country,
                        countryFlagUrl: "",
                        isBlocked: selectedContact.contactNode.blocked,
                        lastChatted: DateTime.now().toString(),
                        clientId: selectedContact.contactNode.id,
                        dndMissed: false,
                        isContact: true,
                        onIncomingTap: () {
                          widget.onIncomingTap();
                        },
                        onOutgoingTap: () {
                          widget.onOutgoingTap();
                        },
                        makeCallWithSid: (channelNumber,
                            channelName,
                            channelSid,
                            channelFlagUrl,
                            outgoingNumber,
                            workspaceSid,
                            memberId,
                            voiceToken,
                            outgoingName,
                            outgoingId,
                            outgoingFlagUrl,
                            outgoingProfilePicture) {
                          widget.makeCallWithSid(
                              channelNumber,
                              channelName,
                              channelSid,
                              channelFlagUrl,
                              outgoingNumber,
                              workspaceSid,
                              memberId,
                              voiceToken,
                              outgoingName,
                              outgoingId,
                              outgoingFlagUrl,
                              outgoingProfilePicture);
                        },
                      ));
              if (returnData != null && returnData is bool && returnData) {
                callLogProvider.doCallLogsApiCall("all");
              }
            },
          );
        });
  }
}
