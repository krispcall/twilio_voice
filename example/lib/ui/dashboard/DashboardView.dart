import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:fcm_unrealistic_heartbeat/fcm_unrealistic_heartbeat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:flutter_incall/flutter_incall.dart';
import 'package:voice_example/api/ApiService.dart';
import 'package:voice_example/api/StreamBase.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/config/Config.dart';
import 'package:voice_example/config/CustomColors.dart';
import 'package:voice_example/constant/Constants.dart';
import 'package:voice_example/constant/Dimens.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/custom_icon/CustomIcon.dart';
import 'package:voice_example/db/common/ps_shared_preferences.dart';
import 'package:voice_example/main.dart';
import 'package:voice_example/provider/country/CountryListProvider.dart';
import 'package:voice_example/provider/login_workspace/LoginWorkspaceProvider.dart';
import 'package:voice_example/provider/user/UserProvider.dart';
import 'package:voice_example/repository/CountryListRepository.dart';
import 'package:voice_example/repository/LoginWorkspaceRepository.dart';
import 'package:voice_example/repository/UserRepository.dart';
import 'package:voice_example/ui/call_logs/CallLogsView.dart';
import 'package:voice_example/ui/common/ZoomScaffold.dart';
import 'package:voice_example/ui/common/dialog/ConfirmDialogView.dart';
import 'package:voice_example/ui/common/dialog/outgoing_call_dialog/OutgoingCallDialog.dart';
import 'package:voice_example/ui/contacts/contact_view/ContactListView.dart';
import 'package:voice_example/ui/dialer/DialerView.dart';
import 'package:voice_example/ui/common/dialog/incoming_call_dialog/IncomingCallDialog.dart';
import 'package:voice_example/ui/members/MemberListView.dart';
import 'package:voice_example/ui/number_setting/NumberSettingView.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/holder/request_holder/VoiceTokenPlatformParamHolder.dart';
import 'package:voice_example/viewobject/model/country/CountryCode.dart';
import 'package:voice_example/viewobject/model/notification/NotificationMessage.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/holder/request_holder/createDeviceInfo/RegisterFcmParamHolder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:voice/twiliovoice.dart';
import 'package:wakelock/wakelock.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const String tag = "DashBoard";

void callbackDispatcher() {
  SendPort sendPortCallInvite = IsolateManagerCallInvite.lookupPortByName();
  SendPort sendPortCallCancelled =
      IsolateManagerCallCancelled.lookupPortByName();

  SendPort sendPortOutgoingCallConnected =
      IsolateManagerOutgoingCallConnected.lookupPortByName();
  SendPort sendPortOutgoingCallDisconnected =
      IsolateManagerOutgoingCallDisconnected.lookupPortByName();
  SendPort sendPortOutgoingCallConnectionFailure =
      IsolateManagerOutgoingCallConnectionFailure.lookupPortByName();
  SendPort sendPortOutgoingCallQualityWarning =
      IsolateManagerOutgoingCallQualityWarningsChanged.lookupPortByName();
  SendPort sendPortOutgoingCallRinging =
      IsolateManagerOutgoingCallRinging.lookupPortByName();
  SendPort sendPortOutgoingCallReconnecting =
      IsolateManagerOutgoingCallReconnecting.lookupPortByName();
  SendPort sendPortOutgoingCallReconnected =
      IsolateManagerOutgoingCallReconnected.lookupPortByName();

  SendPort sendPortIncomingCallConnected =
      IsolateManagerIncomingCallConnected.lookupPortByName();
  SendPort sendPortIncomingCallDisconnected =
      IsolateManagerIncomingCallDisconnected.lookupPortByName();
  SendPort sendPortIncomingCallConnectionFailure =
      IsolateManagerIncomingCallConnectionFailure.lookupPortByName();
  SendPort sendPortIncomingCallQualityWarning =
      IsolateManagerIncomingCallQualityWarningsChanged.lookupPortByName();
  SendPort sendPortIncomingCallRinging =
      IsolateManagerIncomingCallRinging.lookupPortByName();
  SendPort sendPortIncomingCallReconnecting =
      IsolateManagerIncomingCallReconnecting.lookupPortByName();
  SendPort sendPortIncomingCallReconnected =
      IsolateManagerIncomingCallReconnected.lookupPortByName();

  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'onCallInvite':
        sendPortCallInvite.send(inputData);
        break;
      case 'onCancelledCallInvite':
        sendPortCallCancelled.send(inputData);
        break;
      case 'incomingConnected':
        sendPortIncomingCallConnected.send(inputData);
        break;
      case 'incomingDisconnected':
        sendPortIncomingCallDisconnected.send(inputData);
        break;
      case 'incomingConnectFailure':
        sendPortIncomingCallConnectionFailure.send(inputData);
        break;
      case 'incomingCallQualityWarningsChanged':
        sendPortIncomingCallQualityWarning.send(inputData);
        break;
      case 'incomingRinging':
        sendPortIncomingCallRinging.send(inputData);
        break;
      case 'incomingReconnecting':
        sendPortIncomingCallReconnecting.send(inputData);
        break;
      case 'incomingReconnected':
        sendPortIncomingCallReconnected.send(inputData);
        break;
      case 'outGoingCallConnected':
        sendPortOutgoingCallConnected.send(inputData);
        break;
      case 'outGoingCallDisconnected':
        sendPortOutgoingCallDisconnected.send(inputData);
        break;
      case 'outGoingCallConnectFailure':
        sendPortOutgoingCallConnectionFailure.send(inputData);
        break;
      case 'outGoingCallCallQualityWarningsChanged':
        sendPortOutgoingCallQualityWarning.send(inputData);
        break;
      case 'outGoingCallRinging':
        sendPortOutgoingCallRinging.send(inputData);
        break;
      case 'outGoingCallReconnecting':
        sendPortOutgoingCallReconnecting.send(inputData);
        break;
      case 'outGoingCallReconnected':
        sendPortOutgoingCallReconnected.send(inputData);
        break;
    }
    return Future.value(true);
  });
}

class DashboardView extends StatefulWidget {
  static EventBus ebTransferData = EventBus();
  static EventBus outgoingEvent = EventBus();
  static EventBus incomingEvent = EventBus();
  static EventBus expireTokenLogin = EventBus();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<DashboardView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController animationController;
  bool isFirstTime = true;
  int currentIndex = Const.REQUEST_CODE_MENU_GET_STARTED_FRAGMENT;
  bool bottomAppBarToggleVisibility = true;
  MenuController menuController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  WebSocketController webSocketController = WebSocketController();
  ApiService apiService = ApiService();
  List<CountryCode> countryCodeList;
  Timer timerFcmConfigure;
  bool isOnline = true;
  Duration duration = Duration(seconds: 1);
  int secondsPassedIncoming = 0, secondsIncoming = 0, minutesIncoming = 0;
  Timer timerIncoming;

  int secondsPassedOutgoing = 0, secondsOutgoing = 0, minutesOutgoing = 0;
  Timer timerOutgoing;

  UserRepository userRepository;
  UserProvider userProvider;

  LoginWorkspaceRepository loginWorkspaceRepository;
  LoginWorkspaceProvider loginWorkspaceProvider;

  CountryRepository countryRepository;
  CountryListProvider countryListProvider;

  ValueHolder valueHolder;

  bool error = false;
  String errorText = "";
  String uniqueKey = "";

  NotificationMessage notificationMessage = NotificationMessage();

  IncallManager inCallManager = IncallManager();

  bool incomingIsShowing = false;
  bool incomingIsCallConnected = false;
  bool incomingIsMuted = false;
  bool incomingIsOnHold = false;
  String incomingDigits = "";
  bool incomingIsSpeakerOn = false;
  bool incomingIsRecord = false;

  bool outgoingIsShowing = false;
  bool outgoingIsCallConnected = false;
  bool outgoingIsMuted = false;
  bool outgoingIsOnHold = false;
  String outgoingDigits = "";
  bool outgoingIsSpeakerOn = false;
  bool outgoingIsRecord = false;

  String outgoingChannelNumber;
  String outgoingChannelName;
  String outgoingChannelSid;
  String outgoingChannelFlagUrl;
  String outgoingNumber;
  String outgoingName;
  String outgoingId;
  String outgoingFlagUrl;
  String outgoingProfilePicture;

  ///Outgoing Receiver
  ReceivePort receiverPortOutgoingOnCallConnected = ReceivePort();
  ReceivePort receiverPortOutgoingOnCallDisconnected = ReceivePort();
  ReceivePort receiverPortOutgoingCallConnectionFailure = ReceivePort();
  ReceivePort receiverPortOutgoingCallQualityWarningsChanged = ReceivePort();
  ReceivePort receiverPortOutgoingCallRinging = ReceivePort();
  ReceivePort receiverPortOutgoingCallReconnecting = ReceivePort();
  ReceivePort receiverPortOutgoingCallReconnected = ReceivePort();

  ///Incoming Receiver
  ReceivePort receiverPortIncomingOnCallConnected = ReceivePort();
  ReceivePort receiverPortIncomingOnCallDisconnected = ReceivePort();
  ReceivePort receiverPortIncomingCallConnectionFailure = ReceivePort();
  ReceivePort receiverPortIncomingCallQualityWarningsChanged = ReceivePort();
  ReceivePort receiverPortIncomingCallRinging = ReceivePort();
  ReceivePort receiverPortIncomingCallReconnecting = ReceivePort();
  ReceivePort receiverPortIncomingCallReconnected = ReceivePort();

  DateTime loginClickTime;
  DateTime notificationTiming;

  @override
  void initState() {
    super.initState();
    valueHolder = Provider.of<ValueHolder>(context, listen: false);

    userRepository = Provider.of<UserRepository>(context, listen: false);
    userProvider =
        UserProvider(userRepository: userRepository, valueHolder: valueHolder);

    loginWorkspaceRepository =
        Provider.of<LoginWorkspaceRepository>(context, listen: false);
    loginWorkspaceProvider = LoginWorkspaceProvider(
        loginWorkspaceRepository: loginWorkspaceRepository,
        valueHolder: valueHolder);

    countryRepository = Provider.of<CountryRepository>(context, listen: false);
    countryListProvider =
        CountryListProvider(countryListRepository: countryRepository);

    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    WidgetsBinding.instance.addObserver(this);
    menuController = MenuController(
      vSync: this,
    )..addListener(() => setState(() {}));

    animationController =
        AnimationController(duration: Config.animation_duration, vsync: this);

    notificationTiming = DateTime.now();

    if (userRepository.getLoginUserId() != null &&
        userRepository.getLoginUserId().isNotEmpty) {
      try {
        AwesomeNotifications().createdStream.listen((receivedNotification) {});

        AwesomeNotifications()
            .displayedStream
            .listen((receivedNotification) {});

        AwesomeNotifications()
            .dismissedStream
            .listen((receivedNotification) {});

        AwesomeNotifications().actionStream.listen((receivedNotification) {
          processDefaultActionReceived(receivedNotification);
        });
      } catch (e) {
      }
    }

    getUniQueKey();

    IsolateManagerOutgoingCallDisconnected.registerPortWithName(
        receiverPortOutgoingOnCallDisconnected.sendPort);
    IsolateManagerOutgoingCallConnected.registerPortWithName(
        receiverPortOutgoingOnCallConnected.sendPort);
    IsolateManagerOutgoingCallConnectionFailure.registerPortWithName(
        receiverPortOutgoingCallConnectionFailure.sendPort);
    IsolateManagerOutgoingCallQualityWarningsChanged.registerPortWithName(
        receiverPortOutgoingCallQualityWarningsChanged.sendPort);
    IsolateManagerOutgoingCallRinging.registerPortWithName(
        receiverPortOutgoingCallRinging.sendPort);
    IsolateManagerOutgoingCallReconnecting.registerPortWithName(
        receiverPortOutgoingCallReconnecting.sendPort);
    IsolateManagerOutgoingCallReconnected.registerPortWithName(
        receiverPortOutgoingCallReconnected.sendPort);

    IsolateManagerIncomingCallDisconnected.registerPortWithName(
        receiverPortIncomingOnCallDisconnected.sendPort);
    IsolateManagerIncomingCallConnected.registerPortWithName(
        receiverPortIncomingOnCallConnected.sendPort);
    IsolateManagerIncomingCallConnectionFailure.registerPortWithName(
        receiverPortIncomingCallConnectionFailure.sendPort);
    IsolateManagerIncomingCallQualityWarningsChanged.registerPortWithName(
        receiverPortIncomingCallQualityWarningsChanged.sendPort);
    IsolateManagerIncomingCallRinging.registerPortWithName(
        receiverPortIncomingCallRinging.sendPort);
    IsolateManagerIncomingCallReconnecting.registerPortWithName(
        receiverPortIncomingCallReconnecting.sendPort);
    IsolateManagerIncomingCallReconnected.registerPortWithName(
        receiverPortIncomingCallReconnected.sendPort);

    voiceClient.onCancelledCallInvite.listen((event) {
      Utils.cancelNotification();
      Utils.stopRingTone();
      setState(() {
        incomingIsShowing = false;
        if (!incomingIsCallConnected) {
          Utils.showToastMessage(Utils.getString("disConnected"));
          Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
        }
      });
    });

    ///Outgoing Events Foreground
    handleForegroundOutgoingEvents();

    ///Outgoing Event Background
    handleBackgroundOutgoingEvents();

    ///Incoming Event Foreground
    handleForegroundIncomingEvents();

    ///Incoming Event Background
    handleBackgroundIncomingEvents();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      DashboardView.expireTokenLogin.on().listen((event) {
        if (UserProvider.boolIsTokenChanged) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              RoutePaths.home, (Route<dynamic> route) => false);
        }
      });

      getCountryCodeListFromDB();
      refreshVoiceToken();
    });

    if (userProvider.getUserOnlineStatus() != null) {
      if (userProvider.getUserOnlineStatus()) {
        webSocketController.initWebSocketConnection();
        webSocketController.sendData();
      } else {
        webSocketController.onClose();
      }
    }
    fcmWake();
  }

  ///Refresh voice according to ttl
  void refreshVoiceToken() {
    fcmConfigure();
    timerFcmConfigure = Timer.periodic(Duration(minutes: 15), (Timer t) {
      fcmConfigure();
    });
  }

  ///Fcm Wake
  void fcmWake() {
    Timer.periodic(Duration(minutes: 1), (Timer t) async {
      var s = await FcmUnrealisticHeartbeat.init ?? "Can not Init";
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timerFcmConfigure?.cancel();
    AwesomeNotifications().createdSink.close();
    AwesomeNotifications().displayedSink.close();
    AwesomeNotifications().dismissedSink.close();
    AwesomeNotifications().actionSink.close();
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    ReceivePort receiverPortOnCallInvite = ReceivePort();
    IsolateManagerCallInvite.registerPortWithName(
        receiverPortOnCallInvite.sendPort);
    receiverPortOnCallInvite.listen((callBackData) async {
      if (callBackData != null) {
        Data data = Data(
          id: 1,
          twiFrom: callBackData["twi_from"],
          twiTo: callBackData["twi_to"],
          twiCallSid: callBackData["twi_call_sid"],
          customParameters: CustomParameters(
            afterHold: callBackData["after_hold"],
            channelSid: callBackData["channel_sid"],
            contactName: callBackData["contact_name"],
            contactNumber: callBackData["contact_number"],
            conversationId: callBackData["conversation_id"],
          ),
          channelInfo: ChannelInfo(
            id: callBackData["id"],
            number: callBackData["number"],
            countryLogo: callBackData["country_logo"],
            countryCode: callBackData["country_code"],
            name: callBackData["name"],
            country: callBackData["country"],
            numberSid: callBackData["number_sid"],
          ),
        );
        notificationMessage.data = data;
        if (!incomingIsShowing) {
          setState(() {
            incomingIsShowing = true;
            showIncomingBottomSheet();
          });
        }
      }
    });

    ReceivePort receiverPortOnCallCancelled = ReceivePort();
    IsolateManagerCallCancelled.registerPortWithName(
        receiverPortOnCallCancelled.sendPort);
    receiverPortOnCallCancelled.listen((callBackData) {
      Utils.cancelNotification();
      Utils.stopRingTone();
      Utils.showToastMessage(Utils.getString("disConnected"));
      setState(() {
        incomingIsShowing = false;
        if (!incomingIsCallConnected) {
          Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
        }
      });
    });
  }

  Future<void> processDefaultActionReceived(
      ReceivedAction receivedNotification) async {
    if (receivedNotification.buttonKeyPressed == 'reject') {
      Future.delayed(Duration(seconds: 2)).then((value) {
        voiceClient.rejectCall();
        Utils.cancelNotification();
        Utils.stopRingTone();
        Utils.showToastMessage(Utils.getString("disConnected"));
        setState(() {
          incomingIsShowing = false;
          Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
        });
      });
    } else if (receivedNotification.buttonKeyPressed == 'accept') {
      Future.delayed(Duration(seconds: 2)).then((value) {
        if (isRedundantClick(DateTime.now())) {
          return;
        }
        voiceClient.acceptCall();
        Utils.stopRingTone();
        Utils.cancelNotification();
        Data data = Data().fromMap(receivedNotification.payload);
        notificationMessage.data = data;
        setState(() {
          incomingIsShowing = true;
          incomingIsCallConnected = true;
          showIncomingBottomSheet();
        });
      });
    } else if (receivedNotification.buttonKeyPressed == 'view') {
      Utils.cancelNotification();
      setState(() {
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
        currentIndex = Const.REQUEST_CODE_MENU_CALLS_FRAGMENT;
      });
    } else {
      if (receivedNotification.channelKey ==
          Const.NOTIFICATION_CHANNEL_CALL_INCOMING) {
        Data data = Data().fromMap(receivedNotification.payload);
        notificationMessage.data = data;
        Utils.stopRingTone();
        Utils.cancelNotification();
        setState(() {
          incomingIsShowing = true;
          showIncomingBottomSheet();
        });
      } else if (receivedNotification.channelKey ==
          Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_OUTGOING) {
        setState(() {
          outgoingIsShowing = true;
          showOutgoingBottomSheet();
        });
      }
      if (receivedNotification.channelKey ==
          Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_INCOMING) {
        Data data = Data().fromMap(receivedNotification.payload);
        notificationMessage.data = data;
        setState(() {
          incomingIsShowing = true;
          showIncomingBottomSheet();
        });
      } else if (receivedNotification.channelKey ==
          Const.NOTIFICATION_SMS_CHANNEL) {
        setState(() {
          currentIndex = Const.REQUEST_CODE_MENU_CALLS_FRAGMENT;
        });
      }
    }
  }

  int getBottomNavigationIndex(int param) {
    int index = 0;
    switch (param) {
      case Const.REQUEST_CODE_MENU_CALLS_FRAGMENT:
        index = 0;
        break;
      case Const.REQUEST_CODE_MENU_MEMBER_LIST_FRAGMENT:
        index = 1;
        break;
      case Const.REQUEST_CODE_MENU_DIALER_FRAGMENT:
        index = 2;
        break;
      case Const.REQUEST_CODE_MENU_CONTACTS_FRAGMENT:
        index = 3;
        break;
      case Const.REQUEST_CODE_MENU_NUMBER_SETTING:
        index = 4;
        break;
      default:
        index = 0;
        break;
    }
    return index;
  }

  dynamic getIndexFromBottomNavigationIndex(int param) {
    int index = Const.REQUEST_CODE_MENU_CALLS_FRAGMENT;
    String title;
    switch (param) {
      case 0:
        index = Const.REQUEST_CODE_MENU_CALLS_FRAGMENT;
        title = 'Call Box'; // TODO(vivek): use Localizatin string
        break;
      case 1:
        index = Const.REQUEST_CODE_MENU_MEMBER_LIST_FRAGMENT;
        title = 'Member'; //
        break;
      case 2:
        index = Const.REQUEST_CODE_MENU_DIALER_FRAGMENT;
        title = 'Dialer'; // TODO(vivek): use Localizatin string
        break;
      case 3:
        index = Const.REQUEST_CODE_MENU_CONTACTS_FRAGMENT;
        title = 'Contacts';
        break;
      case 4:
        index = Const.REQUEST_CODE_MENU_NUMBER_SETTING;
        title = 'Number Setting'; // TODO(vivek): use Localizatin string
        break;
      default:
        index = 0;
        title = 'Calls'; // TODO(vivek): use Localizatin string
        break;
    }
    return <dynamic>[title, index];
  }

  void getUniQueKey() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        uniqueKey = iosInfo.identifierForVendor;
      });
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        uniqueKey = androidInfo.androidId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;

    if (isFirstTime) {
      isFirstTime = false;
      requestRecordPermission();
      if (valueHolder != null &&
          valueHolder.loginUserId != null &&
          valueHolder.loginUserId != "") {
        currentIndex = Const.REQUEST_CODE_MENU_CALLS_FRAGMENT;
        getCountryCodeListFromDB();
        userProvider.replaceIncomingCallNotificationSetting(true);
        userProvider.replaceSmsNotificationSetting(true);
        refreshVoiceToken();
      } else {
        if (timerFcmConfigure != null) {
          timerFcmConfigure.cancel();
        }

        currentIndex = Const.REQUEST_CODE_MENU_GET_STARTED_FRAGMENT;
      }
    }

    Future<void> updateSelectedIndexWithAnimation(
        String title, int index) async {
      await animationController.reverse().then<dynamic>((void data) {
        if (!mounted) {
          return;
        }
        setState(() {
          currentIndex = index;
        });
      });
    }

    Future<bool> _onWillPop() {
      return showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                    description: Utils.getString('areYouSureToExit'),
                    leftButtonText: Utils.getString('cancel'),
                    rightButtonText: Utils.getString('ok').toUpperCase(),
                    onAgreeTap: () {
                      SystemNavigator.pop();
                    });
              }) ??
          false;
    }

    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    return WillPopScope(
        onWillPop: _onWillPop,
        child: ChangeNotifierProvider(
          create: (BuildContext context) {
            return menuController;
          },
          child: ZoomScaffold(
            animationController: animationController,
            animation: animation,
            contentScreen: Scaffold(
              key: scaffoldKey,
              extendBody: true,
              resizeToAvoidBottomInset: true,
              backgroundColor: CustomColors.white,
              bottomNavigationBar: currentIndex ==
                          Const.REQUEST_CODE_MENU_HOME_FRAGMENT ||
                      currentIndex == Const.REQUEST_CODE_MENU_CALLS_FRAGMENT ||
                      currentIndex ==
                          Const.REQUEST_CODE_MENU_CONTACTS_FRAGMENT ||
                      currentIndex ==
                          Const
                              .REQUEST_CODE_MENU_NUMBER_SETTING || //go to profile
                      currentIndex == Const.REQUEST_CODE_MENU_DIALER_FRAGMENT ||
                      currentIndex ==
                          Const.REQUEST_CODE_MENU_MEMBER_LIST_FRAGMENT
                  ? Visibility(
                      visible: bottomAppBarToggleVisibility,
                      child: BottomAppBar(
                        color: CustomColors.white,
                        shape: CircularNotchedRectangle(),
                        notchMargin: 0.01,
                        elevation: Dimens.space1.r,
                        clipBehavior: Clip.hardEdge,
                        child: Container(
                          height: Dimens.space70.h,
                          color: CustomColors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Divider(
                                color: CustomColors.mainDividerColor,
                                height: Dimens.space1.h,
                                thickness: Dimens.space1.h,
                              ),
                              Expanded(
                                child: BottomNavigationBar(
                                  type: BottomNavigationBarType.fixed,
                                  currentIndex:
                                      getBottomNavigationIndex(currentIndex),
                                  showUnselectedLabels: true,
                                  backgroundColor: CustomColors.white,
                                  selectedItemColor: CustomColors.mainColor,
                                  elevation: 0,
                                  iconSize: Dimens.space24.w,
                                  selectedLabelStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          color: CustomColors.mainColor,
                                          fontStyle: FontStyle.normal,
                                          // fontWeight: FontWeight.normal,
                                          fontFamily: Config.manropeSemiBold,
                                          fontSize: Dimens.space12.sp,
                                          letterSpacing: 0),
                                  unselectedLabelStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          color:
                                              CustomColors.textSecondaryColor,
                                          fontStyle: FontStyle.normal,
                                          // fontWeight: FontWeight.normal,
                                          fontFamily: Config.manropeSemiBold,
                                          fontSize: Dimens.space12.sp,
                                          letterSpacing: 0),
                                  selectedFontSize: Dimens.space12.sp,
                                  unselectedFontSize: Dimens.space12.sp,
                                  unselectedItemColor:
                                      CustomColors.textSecondaryColor,
                                  showSelectedLabels: true,
                                  onTap: (int index) {
                                    final dynamic _returnValue =
                                        getIndexFromBottomNavigationIndex(
                                            index);
                                    updateSelectedIndexWithAnimation(
                                        _returnValue[0], _returnValue[1]);
                                  },
                                  items: <BottomNavigationBarItem>[
                                    BottomNavigationBarItem(
                                      icon: Icon(
                                        CustomIcon.icon_activity_unselected,
                                        size: Dimens.space24.w,
                                      ),
                                      activeIcon: Icon(
                                        CustomIcon.icon_activity_selected,
                                        size: Dimens.space24.w,
                                      ),
                                      label: Utils.getString('calls'),
                                    ),
                                    BottomNavigationBarItem(
                                      activeIcon: Icon(
                                        CustomIcon.icon_contact_selected,
                                        size: Dimens.space24.w,
                                      ),
                                      icon: Icon(
                                        CustomIcon.icon_contact_unselected,
                                        size: Dimens.space24.w,
                                      ),
                                      label: Utils.getString('members'),
                                    ),
                                    BottomNavigationBarItem(
                                      activeIcon: Icon(
                                        CustomIcon.icon_dialer_selected,
                                        size: Dimens.space24.w,
                                      ),
                                      icon: Icon(
                                        CustomIcon.icon_dialer_unselected,
                                        size: Dimens.space24.w,
                                      ),
                                      label: Utils.getString('dialer'),
                                    ),
                                    BottomNavigationBarItem(
                                      activeIcon: Icon(
                                        CustomIcon.icon_contacts_selected,
                                        size: Dimens.space24.w,
                                      ),
                                      icon: Icon(
                                        CustomIcon.icon_contacts_unselected,
                                        size: Dimens.space24.w,
                                      ),
                                      label: Utils.getString('contacts'),
                                    ),
                                    BottomNavigationBarItem(
                                      activeIcon: Icon(
                                        CustomIcon.icon_mores_selected,
                                        size: Dimens.space24.w,
                                      ),
                                      icon: Icon(
                                        CustomIcon.icon_mores_unselected,
                                        size: Dimens.space24.w,
                                      ),
                                      label: Utils.getString('more'),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : null,
              body: MultiProvider(
                providers: <SingleChildWidget>[
                  ChangeNotifierProvider<CountryListProvider>(
                      lazy: false,
                      create: (BuildContext context) {
                        this.countryListProvider = CountryListProvider(
                            countryListRepository: countryRepository);
                        return countryListProvider;
                      }),
                  ChangeNotifierProvider<UserProvider>(
                      lazy: false,
                      create: (BuildContext context) {
                        this.userProvider = UserProvider(
                            userRepository: userRepository,
                            valueHolder: valueHolder);
                        return userProvider;
                      }),
                  ChangeNotifierProvider<LoginWorkspaceProvider>(
                      lazy: false,
                      create: (BuildContext context) {
                        this.loginWorkspaceProvider = LoginWorkspaceProvider(
                            loginWorkspaceRepository: loginWorkspaceRepository,
                            valueHolder: valueHolder);
                        return loginWorkspaceProvider;
                      }),
                ],
                child: Consumer<CountryListProvider>(
                  builder: (BuildContext context, CountryListProvider provider,
                      Widget child) {
                    if (currentIndex ==
                        Const.REQUEST_CODE_MENU_CONTACTS_FRAGMENT) {
                      animationController.forward();
                      return ContactListView(
                        animationController: animationController,
                        onLeadingTap: () {
                          Provider.of<MenuController>(context, listen: false)
                              .toggle();
                        },
                        onIncomingTap: () {
                          setState(() {
                            incomingIsShowing = true;
                            showIncomingBottomSheet();
                          });
                        },
                        onOutgoingTap: () {
                          setState(() {
                            outgoingIsShowing = true;
                            showOutgoingBottomSheet();
                          });
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
                          makeCallWithSid(
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
                            outgoingProfilePicture,
                          );
                        },
                      );
                    } else if (currentIndex ==
                        Const.REQUEST_CODE_MENU_CALLS_FRAGMENT) {
                      animationController.forward();
                      return CallLogsView(
                        animationController: animationController,
                        onLeadingTap: () {
                          Provider.of<MenuController>(context, listen: false)
                              .toggle();
                        },
                        onSelectAllCheckBoxToggle: (value) {
                          setState(() {
                            bottomAppBarToggleVisibility = value;
                          });
                        },
                        onCallTap: () {
                          setState(() {
                            currentIndex =
                                Const.REQUEST_CODE_MENU_DIALER_FRAGMENT;
                          });
                        },
                        onIncomingTap: () {
                          setState(() {
                            incomingIsShowing = true;
                            showIncomingBottomSheet();
                          });
                        },
                        onOutgoingTap: () {
                          setState(() {
                            outgoingIsShowing = true;
                            showOutgoingBottomSheet();
                          });
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
                          makeCallWithSid(
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
                            outgoingProfilePicture,
                          );
                        },
                      );
                    } else if (currentIndex ==
                        Const.REQUEST_CODE_MENU_NUMBER_SETTING) {
                      if (Provider.of<MenuController>(context, listen: false)
                              .state ==
                          MenuState.open) {
                        Provider.of<MenuController>(context, listen: false)
                            .toggle();
                      }
                      animationController.forward();
                      return NumberSettingView(
                        animationController: animationController,
                      );
                    } else if (currentIndex ==
                        Const.REQUEST_CODE_MENU_MEMBER_LIST_FRAGMENT) {
                      return MemberListView(
                        animationController: animationController,
                        onLeadingTap: () {
                          setState(() {
                            currentIndex =
                                Const.REQUEST_CODE_MENU_CALLS_FRAGMENT;
                          });
                        },
                        onIncomingTap: () {
                          setState(() {
                            incomingIsShowing = true;
                            showIncomingBottomSheet();
                          });
                        },
                        onOutgoingTap: () {
                          setState(() {
                            outgoingIsShowing = true;
                            showOutgoingBottomSheet();
                          });
                        },
                      );
                    } else if (currentIndex ==
                        Const.REQUEST_CODE_MENU_DIALER_FRAGMENT) {
                      animationController.forward();
                      return DialerView(
                        animationController: animationController,
                        countryList: countryCodeList,
                        onLeadingTap: () {
                          Provider.of<MenuController>(context, listen: false)
                              .toggle();
                        },
                        defaultCountryCode:
                            countryListProvider.getDefaultCountryCode(),
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
                          makeCallWithSid(
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
                            outgoingProfilePicture,
                          );
                        },
                        onIncomingTap: () {
                          setState(() {
                            incomingIsShowing = true;
                            showIncomingBottomSheet();
                          });
                        },
                        onOutgoingTap: () {
                          setState(() {
                            outgoingIsShowing = true;
                            showOutgoingBottomSheet();
                          });
                        },
                      );
                    } else {
                      animationController.forward();
                      return CallLogsView(
                        animationController: animationController,
                        onLeadingTap: () {
                          Provider.of<MenuController>(context, listen: false)
                              .toggle();
                        },
                        onSelectAllCheckBoxToggle: (value) {
                          setState(() {
                            bottomAppBarToggleVisibility = value;
                          });
                        },
                        onCallTap: () {
                          setState(() {
                            currentIndex =
                                Const.REQUEST_CODE_MENU_DIALER_FRAGMENT;
                          });
                        },
                        onIncomingTap: (notificationMessage) {
                          setState(() {
                            incomingIsShowing = true;
                            showIncomingBottomSheet();
                          });
                        },
                        onOutgoingTap: () {
                          setState(() {
                            outgoingIsShowing = true;
                            showOutgoingBottomSheet();
                          });
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
                          makeCallWithSid(
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
                            outgoingProfilePicture,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
            onIncomingTap: () {
              setState(() {
                incomingIsShowing = true;
                showIncomingBottomSheet();
              });
            },
            onOutgoingTap: () {
              setState(() {
                outgoingIsShowing = true;
                showOutgoingBottomSheet();
              });
            },
          ),
        ));
  }

  void makeCallWithSid(
      String channelNumber,
      String channelName,
      String channelSid,
      String channelFlagUrl,
      String outgoingNumber,
      String workspaceSid,
      String memberId,
      String voiceToken,
      String outgoingName,
      String outgoingId,
      String outgoingFlagUrl,
      String outgoingProfilePicture) async {
    voiceClient.makeCallWithSid(
      outgoingNumber,
      channelNumber,
      workspaceSid,
      channelSid,
      memberId,
      voiceToken,
    );

    setState(() {
      outgoingChannelNumber = channelNumber;
      outgoingChannelName = channelName;
      outgoingChannelSid = channelSid;
      outgoingChannelFlagUrl = channelFlagUrl;
      this.outgoingNumber = outgoingNumber;
      this.outgoingName = outgoingName;
      this.outgoingId = outgoingId;
      this.outgoingFlagUrl = outgoingFlagUrl;
      this.outgoingProfilePicture = outgoingProfilePicture;
      outgoingIsShowing = true;
      showOutgoingBottomSheet();
    });
  }

  void fcmConfigure() async {
    await Firebase.initializeApp();
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    //Refetch access Token
    Resources<String> refreshAccessToken =
        await loginWorkspaceProvider.doRefreshTokenApiCall();
    if (refreshAccessToken.data != null && refreshAccessToken.data.isNotEmpty) {
      // Refetch Voice Token
      VoiceTokenPlatformParamHolder voiceTokenPlatformParamHolder =
          VoiceTokenPlatformParamHolder(
              platform: Platform.isIOS ? "IPHONE" : "ANDROID");
      Resources<String> voiceToken = await loginWorkspaceProvider
          .doVoiceTokenApiCall(voiceTokenPlatformParamHolder.toMap());

      if (voiceToken != null && voiceToken.data != null) {
        if (voiceClient == null) {
          voiceClient = VoiceClient(voiceToken.data);
        }

        voiceClient
            .registerForNotification(
                voiceToken.data,
                Platform.isIOS
                    ? await FirebaseMessaging.instance.getAPNSToken()
                    : await FirebaseMessaging.instance.getToken())
            .then((value) async {
          if (value) {
            loginWorkspaceProvider.replaceVoiceToken(voiceToken.data);
            RegisterFcmParamHolder registerFcmParamHolder =
                RegisterFcmParamHolder(
                    fcmRegistrationId:
                        await FirebaseMessaging.instance.getToken(),
                    version: Config.appVersion,
                    platform: Platform.isIOS
                        ? Utils.getString("ios")
                        : Utils.getString("android"));
            loginWorkspaceProvider
                .doDeviceRegisterApiCall(registerFcmParamHolder.toMap());
            // Refetch Voice Token

            if (Platform.isIOS) {
              _fcm.requestPermission();
            }
            _fcm.setAutoInitEnabled(true);
            _fcm.subscribeToTopic(
                Const.NOTIFICATION_CHANNEL_CALL_INCOMING_TOPIC);
            _fcm.subscribeToTopic(
                Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_TOPIC_OUTGOING);
            _fcm.subscribeToTopic(
                Const.NOTIFICATION_CHANNEL_CALL_IN_PROGRESS_TOPIC_INCOMING);
            _fcm.subscribeToTopic(Const.NOTIFICATION_CHANNEL_SMS_TOPIC);

            await FirebaseMessaging.instance
                .setForegroundNotificationPresentationOptions(
              alert: true,
              badge: true,
              sound: false,
            );

            FirebaseMessaging.onMessage.listen((RemoteMessage message) {

              if (message.data.containsKey("twi_account_sid")) {
                Map<String, dynamic> map = Map();
                map["data"] = message.data;
                voiceClient.handleMessage(map).then((result) {
                  Data data = Data().fromMap(result);
                  data.channelInfo.numberSid = "abcde";
                  data.customParameters.contactName = "Unknown";
                  notificationMessage.data = data;
                  // Utils.playRingTone();
                  Utils.showNotificationWithActionButtons(notificationMessage, notificationTiming);
                  setState(() {
                    incomingIsShowing = true;
                    showIncomingBottomSheet();
                  });
                });
              } else {
                Utils.playSmsTone();
                Utils.showSmsNotification(
                    message.data["title"] +
                        " (${notificationTiming.hour}:${notificationTiming.minute}::${notificationTiming.second})",
                    message.data["body"]);
              }
            });

            FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
          } else {
            fcmConfigure();
          }
        });
      }
    }
  }

  Future<bool> requestRecordPermission() async {
    Map<Permission, PermissionStatus> permissionStatus = await [
      Permission.microphone,
      Permission.accessMediaLocation,
      Permission.mediaLibrary,
      Permission.phone,
      Permission.storage,
      Permission.notification,
      Permission.camera,
      Permission.ignoreBatteryOptimizations,
    ].request();

    for (int i = 0; i < permissionStatus.length; i++) {
      if (permissionStatus[i].isGranted) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  void getCountryCodeListFromDB() async {
    countryCodeList = await countryListProvider.getCountryListFromDb();
  }

  void handleForegroundOutgoingEvents() {
    voiceClient.outGoingCallRinging.listen((event) {
      inCallManager.setSpeakerphoneOn(false);
      Utils.showToastMessage("Ringing");
      Wakelock.enable();
      DashboardView.outgoingEvent.fire({
        "outgoingEvent": "outGoingCallRinging",
        "callSid": event.callSid,
        "state": Utils.getString("ringing")
      });
    });

    voiceClient.outGoingCallDisconnected.listen((event) {
      Utils.showToastMessage("Disconnected");
      Wakelock.disable();
      timerOutgoing?.cancel();
      secondsPassedOutgoing = 0;
      secondsOutgoing = 0;
      minutesOutgoing = 0;
      outgoingIsCallConnected = false;
      outgoingIsMuted = false;
      outgoingIsOnHold = false;
      outgoingDigits = "";
      inCallManager.setSpeakerphoneOn(false);
      outgoingIsSpeakerOn = false;
      outgoingIsRecord = false;
      Utils.stopRingTone();
      Future.delayed(Duration(seconds: 1)).then((value) {
        Utils.cancelNotification();
      });
      DashboardView.outgoingEvent.fire({
        "outgoingEvent": "outGoingCallDisconnected",
        "state": Utils.getString("disconnected")
      });
      setState(() {
        outgoingIsShowing = false;
        outgoingIsCallConnected = false;
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      });
    });

    voiceClient.outGoingCallConnected.listen((event) {
      Wakelock.enable();
      Utils.showToastMessage("Connected");
      setState(() {
        outgoingIsCallConnected = true;
      });
      timerOutgoing = Timer.periodic(duration, (Timer t) {
        setState(() {
          secondsPassedOutgoing = secondsPassedOutgoing + 1;
          secondsOutgoing = secondsPassedOutgoing % 60;
          minutesOutgoing = secondsPassedOutgoing ~/ 60 % 60;
        });

        Utils.showCallInProgressNotificationOutgoing(
          secondsOutgoing,
          minutesOutgoing,
        );
        DashboardView.outgoingEvent.fire({
          "outgoingEvent": "outGoingCallConnected",
          "channelName": "",
          "channelNumber": "",
          "channelFlagUrl": "",
          "outgoingName": "",
          "outgoingNumber": "",
          "outgoingFlagUrl": "",
          "clientId": "",
          "isRecord": outgoingIsRecord,
          "isSpeakerOn": outgoingIsSpeakerOn,
          "digits": outgoingDigits,
          "isMicMuted": outgoingIsMuted,
          "isOnHold": outgoingIsOnHold,
          "isRinging": false,
          "isConnected": outgoingIsCallConnected,
          "seconds": secondsOutgoing,
          "minutes": minutesOutgoing,
          "state": Utils.getString("connected")
        });
      });
    });

    voiceClient.outGoingCallConnectFailure.listen((event) {
      Utils.showToastMessage("Disconnected");
      Wakelock.disable();
      timerOutgoing?.cancel();
      secondsPassedOutgoing = 0;
      secondsOutgoing = 0;
      minutesOutgoing = 0;
      outgoingIsCallConnected = false;
      outgoingIsMuted = false;
      outgoingIsOnHold = false;
      outgoingDigits = "";
      inCallManager.setSpeakerphoneOn(false);
      outgoingIsSpeakerOn = false;
      outgoingIsRecord = false;
      Utils.stopRingTone();
      Future.delayed(Duration(seconds: 1)).then((value) {
        Utils.cancelNotification();
      });
      DashboardView.outgoingEvent.fire({
        "outgoingEvent": "outGoingCallDisconnected",
        "state": Utils.getString("disconnected")
      });
      setState(() {
        outgoingIsShowing = false;
        outgoingIsCallConnected = false;
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      });
    });

    voiceClient.outGoingCallReconnecting.listen((event) {
      Utils.showToastMessage("Reconnecting");
      Wakelock.enable();
      DashboardView.outgoingEvent
          .fire({"outgoingEvent": "outGoingCallReconnecting"});
    });

    voiceClient.outGoingCallReconnected.listen((event) {
      Utils.showToastMessage("Reconnected");
      Wakelock.enable();
      DashboardView.outgoingEvent
          .fire({"outgoingEvent": "outGoingCallReconnected"});
    });

    voiceClient.outGoingCallCallQualityWarningsChanged.listen((event) {
      Utils.showToastMessage("Internet connection unstable");
      Wakelock.enable();
      DashboardView.outgoingEvent
          .fire({"outgoingEvent": "outGoingCallCallQualityWarningsChanged"});
    });
  }

  void handleBackgroundOutgoingEvents() {
    receiverPortOutgoingCallRinging.listen((message) {
      inCallManager.setSpeakerphoneOn(false);
      Utils.showToastMessage("Ringing");
      Wakelock.enable();
      DashboardView.outgoingEvent.fire({
        "outgoingEvent": "outGoingCallRinging",
        "callSid": message.callSid,
        "state": Utils.getString("ringing")
      });
    });

    receiverPortOutgoingOnCallDisconnected.listen((callBackData) {
      Utils.showToastMessage("Disconnected");
      Wakelock.disable();
      timerOutgoing?.cancel();
      secondsPassedOutgoing = 0;
      secondsOutgoing = 0;
      minutesOutgoing = 0;
      outgoingIsCallConnected = false;
      outgoingIsMuted = false;
      outgoingIsOnHold = false;
      outgoingDigits = "";
      inCallManager.setSpeakerphoneOn(false);
      outgoingIsSpeakerOn = false;
      outgoingIsRecord = false;
      Utils.stopRingTone();
      Future.delayed(Duration(seconds: 1)).then((value) {
        Utils.cancelNotification();
      });
      DashboardView.outgoingEvent.fire({
        "outgoingEvent": "outGoingCallDisconnected",
        "state": Utils.getString("disconnected")
      });
      setState(() {
        outgoingIsShowing = false;
        outgoingIsCallConnected = false;
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      });
    });

    receiverPortOutgoingOnCallConnected.listen((callBackData) {
      Wakelock.enable();
      Utils.showToastMessage("Connected");
      setState(() {
        outgoingIsCallConnected = true;
      });
      timerOutgoing = Timer.periodic(duration, (Timer t) {
        setState(() {
          secondsPassedOutgoing = secondsPassedOutgoing + 1;
          secondsOutgoing = secondsPassedOutgoing % 60;
          minutesOutgoing = secondsPassedOutgoing ~/ 60 % 60;
        });

        Utils.showCallInProgressNotificationOutgoing(
          secondsOutgoing,
          minutesOutgoing,
        );
        DashboardView.outgoingEvent.fire({
          "outgoingEvent": "outGoingCallConnected",
          "channelName": "",
          "channelNumber": "",
          "channelFlagUrl": "",
          "outgoingName": "",
          "outgoingNumber": "",
          "outgoingFlagUrl": "",
          "clientId": "",
          "isRecord": outgoingIsRecord,
          "isSpeakerOn": outgoingIsSpeakerOn,
          "digits": outgoingDigits,
          "isMicMuted": outgoingIsMuted,
          "isOnHold": outgoingIsOnHold,
          "isRinging": false,
          "isConnected": outgoingIsCallConnected,
          "seconds": secondsOutgoing,
          "minutes": minutesOutgoing,
          "state": Utils.getString("connected")
        });
      });
    });

    receiverPortOutgoingCallConnectionFailure.listen((message) {
      Utils.showToastMessage("Disconnected");
      Wakelock.disable();
      timerOutgoing?.cancel();
      secondsPassedOutgoing = 0;
      secondsOutgoing = 0;
      minutesOutgoing = 0;
      outgoingIsCallConnected = false;
      outgoingIsMuted = false;
      outgoingIsOnHold = false;
      outgoingDigits = "";
      inCallManager.setSpeakerphoneOn(false);
      outgoingIsSpeakerOn = false;
      outgoingIsRecord = false;
      Utils.stopRingTone();
      Future.delayed(Duration(seconds: 1)).then((value) {
        Utils.cancelNotification();
      });
      DashboardView.outgoingEvent.fire({
        "outgoingEvent": "outGoingCallDisconnected",
        "state": Utils.getString("disconnected")
      });
      setState(() {
        outgoingIsShowing = false;
        outgoingIsCallConnected = false;
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      });
    });

    receiverPortOutgoingCallReconnecting.listen((message) {
      Utils.showToastMessage("Reconnecting");
      Wakelock.enable();
      DashboardView.outgoingEvent
          .fire({"outgoingEvent": "outGoingCallReconnecting"});
    });

    receiverPortOutgoingCallReconnected.listen((message) {
      Utils.showToastMessage("Reconnected");
      Wakelock.enable();
      DashboardView.outgoingEvent
          .fire({"outgoingEvent": "outGoingCallReconnected"});
    });

    receiverPortOutgoingCallQualityWarningsChanged.listen((message) {
      Utils.showToastMessage("Internet connection unstable");
      Wakelock.enable();
      DashboardView.outgoingEvent
          .fire({"outgoingEvent": "outGoingCallCallQualityWarningsChanged"});
    });
  }

  void handleForegroundIncomingEvents() {
    voiceClient.incomingRinging.listen((event) {
      inCallManager.setSpeakerphoneOn(false);
      Utils.showToastMessage("Ringing");
      Wakelock.enable();
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingRinging",
        "state": Utils.getString("ringing")
      });
    });

    voiceClient.incomingDisconnected.listen((event) {
      Utils.showToastMessage("Disconnected");
      Wakelock.disable();
      timerIncoming?.cancel();
      secondsPassedIncoming = 0;
      secondsIncoming = 0;
      minutesIncoming = 0;
      incomingIsCallConnected = false;
      incomingIsMuted = false;
      incomingIsOnHold = false;
      incomingDigits = "";
      inCallManager.setSpeakerphoneOn(false);
      incomingIsSpeakerOn = false;
      incomingIsRecord = false;
      Utils.stopRingTone();
      Future.delayed(Duration(seconds: 1)).then((value) {
        Utils.cancelNotification();
      });
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingDisconnected",
        "state": Utils.getString("disconnected")
      });
      setState(() {
        incomingIsShowing = false;
        incomingIsCallConnected = false;
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      });
    });

    voiceClient.incomingConnected.listen((event) {
      Wakelock.enable();
      Utils.showToastMessage("Connected");
      timerIncoming = Timer.periodic(duration, (Timer t) {
        secondsPassedIncoming = secondsPassedIncoming + 1;
        secondsIncoming = secondsPassedIncoming % 60;
        minutesIncoming = secondsPassedIncoming ~/ 60 % 60;
        Utils.showCallInProgressNotificationIncoming(
            notificationMessage, minutesIncoming, secondsIncoming);
        DashboardView.incomingEvent.fire({
          "incomingEvent": "incomingConnected",
          "channelName": "",
          "channelNumber": "",
          "channelFlagUrl": "",
          "outgoingName": "",
          "outgoingNumber": "",
          "outgoingFlagUrl": "",
          "clientId": "",
          "isRecord": incomingIsRecord,
          "isSpeakerOn": incomingIsSpeakerOn,
          "digits": incomingDigits,
          "isMicMuted": incomingIsMuted,
          "isOnHold": incomingIsOnHold,
          "isRinging": false,
          "isConnected": incomingIsCallConnected,
          "seconds": secondsIncoming,
          "minutes": minutesIncoming,
          "state": Utils.getString("connected")
        });
      });
    });

    voiceClient.incomingConnectFailure.listen((event) {
      Utils.showToastMessage("Connection Failure");
      Wakelock.disable();
      timerIncoming?.cancel();
      secondsPassedIncoming = 0;
      secondsIncoming = 0;
      minutesIncoming = 0;
      incomingIsCallConnected = false;
      incomingIsMuted = false;
      incomingIsOnHold = false;
      incomingDigits = "";
      inCallManager.setSpeakerphoneOn(false);
      incomingIsSpeakerOn = false;
      incomingIsRecord = false;
      Utils.stopRingTone();
      Future.delayed(Duration(seconds: 1)).then((value) {
        Utils.cancelNotification();
      });
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingConnectFailure",
        "state": Utils.getString("disconnected")
      });
      setState(() {
        incomingIsShowing = false;
        incomingIsCallConnected = false;
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      });
    });

    voiceClient.incomingReconnecting.listen((event) {
      Utils.showToastMessage("Reconnecting");
      Wakelock.enable();
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingReconnecting",
        "state": Utils.getString("reconnecting")
      });
    });

    voiceClient.incomingReconnected.listen((event) {
      Utils.showToastMessage("Reconnected");
      Wakelock.enable();
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingReconnected",
        "state": Utils.getString("connected")
      });
    });

    voiceClient.incomingCallQualityWarningsChanged.listen((event) {
      Utils.showToastMessage("Internet connection unstable");
      Wakelock.enable();
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingCallQualityWarningsChanged",
        "state": Utils.getString("warningInternetConnection")
      });
    });
  }

  void handleBackgroundIncomingEvents() {
    receiverPortIncomingCallRinging.listen((message) {
      inCallManager.setSpeakerphoneOn(false);
      Utils.showToastMessage("Ringing");
      Wakelock.enable();
      DashboardView.incomingEvent.fire({"incomingEvent": "incomingRinging"});
    });

    receiverPortIncomingOnCallDisconnected.listen((callBackData) {
      Utils.showToastMessage("Disconnected");
      Wakelock.disable();
      timerIncoming?.cancel();
      secondsPassedIncoming = 0;
      secondsIncoming = 0;
      minutesIncoming = 0;
      incomingIsCallConnected = false;
      incomingIsMuted = false;
      incomingIsOnHold = false;
      incomingDigits = "";
      inCallManager.setSpeakerphoneOn(false);
      incomingIsSpeakerOn = false;
      incomingIsRecord = false;
      Utils.stopRingTone();
      Future.delayed(Duration(seconds: 1)).then((value) {
        Utils.cancelNotification();
      });
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingDisconnected",
        "state": Utils.getString("disconnected")
      });
      setState(() {
        incomingIsShowing = false;
        incomingIsCallConnected = false;
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      });
    });

    receiverPortIncomingOnCallConnected.listen((callBackData) {
      Utils.showToastMessage("Connected");
      Wakelock.enable();
      timerIncoming = Timer.periodic(duration, (Timer t) {
        secondsPassedIncoming = secondsPassedIncoming + 1;
        secondsIncoming = secondsPassedIncoming % 60;
        minutesIncoming = secondsPassedIncoming ~/ 60 % 60;
        Utils.showCallInProgressNotificationIncoming(
            notificationMessage, minutesIncoming, secondsIncoming);
        DashboardView.incomingEvent.fire({
          "incomingEvent": "incomingConnected",
          "channelName": "",
          "channelNumber": "",
          "channelFlagUrl": "",
          "outgoingName": "",
          "outgoingNumber": "",
          "outgoingFlagUrl": "",
          "clientId": "",
          "isRecord": incomingIsRecord,
          "isSpeakerOn": incomingIsSpeakerOn,
          "digits": incomingDigits,
          "isMicMuted": incomingIsMuted,
          "isOnHold": incomingIsOnHold,
          "isRinging": false,
          "isConnected": incomingIsCallConnected,
          "seconds": secondsIncoming,
          "minutes": minutesIncoming,
        });
      });
    });

    receiverPortIncomingCallConnectionFailure.listen((message) {
      Utils.showToastMessage("Connection Failure");
      Wakelock.disable();
      timerIncoming?.cancel();
      secondsPassedIncoming = 0;
      secondsIncoming = 0;
      minutesIncoming = 0;
      incomingIsCallConnected = false;
      incomingIsMuted = false;
      incomingIsOnHold = false;
      incomingDigits = "";
      inCallManager.setSpeakerphoneOn(false);
      incomingIsSpeakerOn = false;
      incomingIsRecord = false;
      Utils.stopRingTone();
      Future.delayed(Duration(seconds: 1)).then((value) {
        Utils.cancelNotification();
      });
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingConnectFailure",
        "state": Utils.getString("disconnected")
      });
      setState(() {
        incomingIsShowing = false;
        incomingIsCallConnected = false;
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      });
    });

    receiverPortIncomingCallReconnecting.listen((message) {
      Utils.showToastMessage("Reconnecting");
      Wakelock.enable();
      DashboardView.incomingEvent
          .fire({"incomingEvent": "incomingReconnecting"});
    });

    receiverPortIncomingCallReconnected.listen((message) {
      Utils.showToastMessage("Reconnected");
      Wakelock.enable();
      DashboardView.incomingEvent
          .fire({"incomingEvent": "incomingReconnected"});
    });

    receiverPortIncomingCallQualityWarningsChanged.listen((message) {
      Utils.showToastMessage("Internet connection unstable");
      Wakelock.enable();
      DashboardView.incomingEvent
          .fire({"incomingEvent": "incomingCallQualityWarningsChanged"});
    });
  }

  void showIncomingBottomSheet() async {
    setState(() {
      incomingIsShowing = true;
    });
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return IncomingCallDialog(
            notificationMessage: notificationMessage,
            onReject: () {
              voiceClient.rejectCall();
              Utils.showToastMessage(Utils.getString("disConnected"));
              setState(() {
                incomingIsShowing = false;
                incomingIsCallConnected = false;
                Navigator.popUntil(
                    context, ModalRoute.withName(RoutePaths.home));
              });
            },
            onAccept: () {
              voiceClient.acceptCall();
              setState(() {
                incomingIsShowing = true;
                incomingIsCallConnected = true;
              });
            },
            onDisconnect: () {
              voiceClient.disConnect();
              setState(() {
                incomingIsShowing = false;
                incomingIsCallConnected = false;
                Navigator.popUntil(
                    context, ModalRoute.withName(RoutePaths.home));
              });
            },
            onMute: () {
              if (incomingIsMuted) {
                setState(() {
                  incomingIsMuted = false;
                  voiceClient.mute();
                });
              } else {
                setState(() {
                  incomingIsMuted = true;
                  voiceClient.mute();
                });
              }
            },
            onHold: () {
              if (incomingIsCallConnected) {
                if (incomingIsOnHold) {
                  setState(() {
                    incomingIsOnHold = false;
                    voiceClient.hold();
                  });
                } else {
                  setState(() {
                    incomingIsOnHold = true;
                    voiceClient.hold();
                  });
                }
              } else {
                Utils.showToastMessage(Utils.getString("cannotHold"));
              }
            },
            sendDigits: (value) {
              if (incomingIsCallConnected) {
                setState(() {
                  incomingDigits = incomingDigits + value;
                  voiceClient.sendDigit(value);
                });
              } else {
                Utils.showToastMessage(Utils.getString("cannotSendDigit"));
              }
            },
            onSetSpeakerphoneOn: () {
              if (incomingIsSpeakerOn) {
                inCallManager.setSpeakerphoneOn(false);
                setState(() {
                  incomingIsSpeakerOn = false;
                });
              } else {
                inCallManager.setSpeakerphoneOn(true);
                setState(() {
                  incomingIsSpeakerOn = true;
                });
              }
            },
            onRecord: (value) {
              setState(() {
                incomingIsRecord = value;
              });
            },
            onContactTap: () {
              setState(() {
                currentIndex = Const.REQUEST_CODE_MENU_CONTACTS_FRAGMENT;
              });
            },
            onIncomingTap: () {
              setState(() {
                incomingIsShowing = true;
                incomingIsCallConnected = true;
                showIncomingBottomSheet();
              });
            },
            onOutgoingTap: () {
              setState(() {
                outgoingIsShowing = true;
                showOutgoingBottomSheet();
              });
            },
          );
        }).then((value) {
      setState(() {
        incomingIsShowing = false;
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      });
    });
  }

  void showOutgoingBottomSheet() async {
    setState(() {
      outgoingIsShowing = true;
    });
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return OutgoingCallDialog(
            channelNumber: outgoingChannelNumber,
            channelName: outgoingChannelName,
            channelId: outgoingChannelSid,
            channelFlagUrl: outgoingChannelFlagUrl,
            outgoingNumber: outgoingNumber,
            outgoingName: outgoingName,
            clientId: outgoingId,
            outgoingFlagUrl: outgoingFlagUrl,
            outgoingProfilePicture: outgoingProfilePicture,
            onDisconnect: () {
              voiceClient.disConnect();
              setState(() {
                outgoingIsShowing = false;
                outgoingIsCallConnected = false;
                Navigator.popUntil(
                    context, ModalRoute.withName(RoutePaths.home));
              });
            },
            onMute: () {
              if (outgoingIsMuted) {
                setState(() {
                  outgoingIsMuted = false;
                  voiceClient.mute();
                });
              } else {
                setState(() {
                  outgoingIsMuted = true;
                  voiceClient.mute();
                });
              }
            },
            onHold: () {
              if (outgoingIsCallConnected) {
                if (outgoingIsOnHold) {
                  setState(() {
                    outgoingIsOnHold = false;
                    voiceClient.hold();
                  });
                } else {
                  setState(() {
                    outgoingIsOnHold = true;
                    voiceClient.hold();
                  });
                }
              } else {
                Utils.showToastMessage(Utils.getString("cannotHold"));
              }
            },
            sendDigits: (value) {
              if (outgoingIsCallConnected) {
                setState(() {
                  outgoingDigits = outgoingDigits + value;
                  voiceClient.sendDigit(value);
                });
              } else {
                Utils.showToastMessage(Utils.getString("cannotSendDigit"));
              }
            },
            onSetSpeakerphoneOn: () {
              if (outgoingIsSpeakerOn) {
                inCallManager.setSpeakerphoneOn(false);
                setState(() {
                  outgoingIsSpeakerOn = false;
                });
              } else {
                inCallManager.setSpeakerphoneOn(true);
                setState(() {
                  outgoingIsSpeakerOn = true;
                });
              }
            },
            onRecord: (value) {
              setState(() {
                outgoingIsRecord = value;
              });
            },
            onContactTap: () {
              setState(() {
                currentIndex = Const.REQUEST_CODE_MENU_CONTACTS_FRAGMENT;
              });
            },
            onIncomingTap: () {
              setState(() {
                outgoingIsShowing = true;
                outgoingIsCallConnected = true;
                showIncomingBottomSheet();
              });
            },
            onOutgoingTap: () {
              setState(() {
                outgoingIsShowing = true;
                showOutgoingBottomSheet();
              });
            },
          );
        }).then((value) {
      setState(() {
        outgoingIsShowing = false;
        Navigator.popUntil(context, ModalRoute.withName(RoutePaths.home));
      });
    });
  }

  bool isRedundantClick(DateTime currentTime) {
    if (loginClickTime == null) {
      loginClickTime = currentTime;
      return false;
    }
    if (currentTime.difference(loginClickTime).inSeconds < 10) {
      return true;
    }
    loginClickTime = currentTime;
    return false;
  }
}

///Incoming
Future<dynamic> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey("twi_account_sid")) {
    Map<String, dynamic> map = Map();
    map["data"] = message.data;

    voiceClient.handleMessage(map).then((result) {
      Data data = Data.fromJson(json.decode(json.encode(result)));
      data.channelInfo.numberSid = "abcde";
      data.customParameters.contactName = "Unknown";
      NotificationMessage notificationMessage = NotificationMessage();
      notificationMessage.data = data;
      Map<String, dynamic> map = Map();
      map["twi_call_sid"] = data.twiCallSid;
      map["twi_to"] = data.twiTo;
      map["twi_from"] = data.twiFrom;
      map["conversation_id"] = data.customParameters.conversationId;
      map["after_hold"] = data.customParameters.afterHold;
      map["contact_number"] = data.customParameters.contactNumber;
      map["contact_name"] = data.customParameters.contactName;
      map["channel_sid"] = data.customParameters.channelSid;
      map["number"] = data.channelInfo.number;
      map["country"] = data.channelInfo.country;
      map["country_code"] = data.channelInfo.countryCode;
      map["name"] = data.channelInfo.name;
      map["id"] = data.channelInfo.id;
      map["number_sid"] = data.channelInfo.numberSid;
      map["country_logo"] = data.channelInfo.countryLogo;
      // Utils.playRingTone();
      Utils.showNotificationWithActionButtons(notificationMessage,DateTime.now());
      Workmanager().registerOneOffTask(
        "1",
        'onCallInvite',
        initialDelay: Duration(milliseconds: 0),
        inputData: map,
      );
    });

    voiceClient.onCancelledCallInvite.listen((event) {
      Map<String, dynamic> map = Map();
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Workmanager().registerOneOffTask("2", 'onCancelledCallInvite',
          initialDelay: Duration(milliseconds: 0), inputData: map);
    });

    voiceClient.incomingConnected.listen((event) {
      Map<String, dynamic> map = Map();
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Workmanager().registerOneOffTask("3", 'incomingConnected',
          initialDelay: Duration(milliseconds: 0), inputData: map);
    });

    voiceClient.incomingDisconnected.listen((event) {
      Map<String, dynamic> map = Map();
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Utils.showToastMessage("Disconnected");
      Workmanager().registerOneOffTask("4", 'incomingDisconnected',
          initialDelay: Duration(milliseconds: 0), inputData: map);
    });

    voiceClient.incomingConnectFailure.listen((event) {
      Map<String, dynamic> map = Map();
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Utils.showToastMessage("Connection Failure");
      Workmanager().registerOneOffTask(
        "5",
        'incomingConnectFailure',
        initialDelay: Duration(milliseconds: 0),
        inputData: map,
      );
    });

    voiceClient.incomingCallQualityWarningsChanged.listen((event) {
      Map<String, dynamic> map = Map();
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Workmanager().registerOneOffTask(
        "6",
        'incomingCallQualityWarningsChanged',
        initialDelay: Duration(milliseconds: 0),
        inputData: map,
      );
    });

    voiceClient.incomingRinging.listen((event) {
      Map<String, dynamic> map = Map();
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Utils.showToastMessage("Ringing");
      Workmanager().registerOneOffTask(
        "7",
        'incomingRinging',
        initialDelay: Duration(milliseconds: 0),
        inputData: map,
      );
    });

    voiceClient.incomingReconnecting.listen((event) {
      Map<String, dynamic> map = Map();
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Utils.showToastMessage("Reconnecting");
      Workmanager().registerOneOffTask(
        "8",
        'incomingReconnecting',
        initialDelay: Duration(milliseconds: 0),
        inputData: map,
      );
    });

    voiceClient.incomingReconnected.listen((event) {
      Map<String, dynamic> map = Map();
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Utils.showToastMessage("Connected");
      Workmanager().registerOneOffTask("9", 'incomingReconnected',
          initialDelay: Duration(milliseconds: 0), inputData: map);
    });

    voiceClient.outGoingCallConnected.listen((event) {
      Map<String, dynamic> map = Map();
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Utils.showToastMessage("Connected");
      Workmanager().registerOneOffTask("10", 'outGoingCallConnected',
          initialDelay: Duration(milliseconds: 0), inputData: map);
    });

    voiceClient.outGoingCallDisconnected.listen((event) {
      Map<String, dynamic> map = Map();
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Utils.showToastMessage("Disconnected");
      Workmanager().registerOneOffTask(
        "11",
        'outGoingCallDisconnected',
        initialDelay: Duration(milliseconds: 0),
        inputData: map,
      );
    });

    voiceClient.outGoingCallConnectFailure.listen((event) {
      Map<String, dynamic> map = Map();
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Utils.showToastMessage("Connection Failure");
      Workmanager().registerOneOffTask("12", 'outGoingCallConnectFailure',
          initialDelay: Duration(milliseconds: 0), inputData: map);
    });

    voiceClient.outGoingCallCallQualityWarningsChanged.listen((event) {
      Map<String, dynamic> map = Map();
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Utils.showToastMessage("Internet is unstable");
      Workmanager().registerOneOffTask(
        "13",
        'outGoingCallCallQualityWarningsChanged',
        initialDelay: Duration(milliseconds: 0),
        inputData: map,
      );
    });

    voiceClient.outGoingCallRinging.listen((event) {
      Map<String, dynamic> map = Map();
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Utils.showToastMessage("Ringing");
      Workmanager().registerOneOffTask("14", 'outGoingCallRinging',
          initialDelay: Duration(milliseconds: 0), inputData: map);
    });

    voiceClient.outGoingCallReconnecting.listen((event) {
      Map<String, dynamic> map = Map();
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Utils.showToastMessage("Reconnecting");
      Workmanager().registerOneOffTask("15", 'outGoingCallReconnecting',
          initialDelay: Duration(milliseconds: 0), inputData: map);
    });

    voiceClient.outGoingCallReconnected.listen((event) {
      Map<String, dynamic> map = Map();
      map["twi_call_sid"] = event.callSid;
      map["twi_to"] = event.to;
      map["twi_from"] = event.from;
      Utils.showToastMessage("Connected");
      Workmanager().registerOneOffTask("16", 'outGoingCallReconnected',
          initialDelay: Duration(milliseconds: 0), inputData: map);
    });
  } else {
    if (PsSharedPreferences.instance.shared != null) {
      if (PsSharedPreferences.instance.getSmsNotificationSetting() != null &&
          PsSharedPreferences.instance.getSmsNotificationSetting()) {
        Utils.playSmsTone();
        Utils.showSmsNotification(message.data["title"], message.data["body"]);
      }
    } else {
      PsSharedPreferences.instance.futureShared.then((value) {
        if (PsSharedPreferences.instance.getSmsNotificationSetting() != null &&
            PsSharedPreferences.instance.getSmsNotificationSetting()) {
          Utils.playSmsTone();
          Utils.showSmsNotification(
              message.data["title"], message.data["body"]);
        }
      });
    }
  }
}

///Isolate background
class IsolateManagerCallCancelled {
  static const FOREGROUND_PORT_NAME = "foreground_port_call_cancelled";

  static SendPort lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    assert(port != null, "'port' cannot be null.");
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    assert(name != null, "'name' cannot be null.");
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerCallInvite {
  static const FOREGROUND_PORT_NAME = "foreground_port_call_invite";

  static SendPort lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    assert(port != null, "'port' cannot be null.");
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    assert(name != null, "'name' cannot be null.");
    return IsolateNameServer.removePortNameMapping(name);
  }
}

///Isolate Outgoing background
class IsolateManagerOutgoingCallRinging {
  static const FOREGROUND_PORT_NAME = "foreground_port_outgoing_call_ringing";

  static SendPort lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    assert(port != null, "'port' cannot be null.");
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    assert(name != null, "'name' cannot be null.");
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerOutgoingCallConnected {
  static const FOREGROUND_PORT_NAME = "foreground_port_outgoing_call_connected";

  static SendPort lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    assert(port != null, "'port' cannot be null.");
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    assert(name != null, "'name' cannot be null.");
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerOutgoingCallDisconnected {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_outgoing_call_disconnected";

  static SendPort lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    assert(port != null, "'port' cannot be null.");
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    assert(name != null, "'name' cannot be null.");
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerOutgoingCallConnectionFailure {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_outgoing_call_connection_failure";

  static SendPort lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    assert(port != null, "'port' cannot be null.");
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    assert(name != null, "'name' cannot be null.");
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerOutgoingCallQualityWarningsChanged {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_outgoing_call_quality_warnings_changed";

  static SendPort lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    assert(port != null, "'port' cannot be null.");
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    assert(name != null, "'name' cannot be null.");
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerOutgoingCallReconnecting {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_outgoing_call_reconnecting";

  static SendPort lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    assert(port != null, "'port' cannot be null.");
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    assert(name != null, "'name' cannot be null.");
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerOutgoingCallReconnected {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_outgoing_call_reconnected";

  static SendPort lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    assert(port != null, "'port' cannot be null.");
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    assert(name != null, "'name' cannot be null.");
    return IsolateNameServer.removePortNameMapping(name);
  }
}

///Isolate Background Incoming
class IsolateManagerIncomingCallRinging {
  static const FOREGROUND_PORT_NAME = "foreground_port_incoming_call_ringing";

  static SendPort lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    assert(port != null, "'port' cannot be null.");
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    assert(name != null, "'name' cannot be null.");
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerIncomingCallConnected {
  static const FOREGROUND_PORT_NAME = "foreground_port_incoming_call_connected";

  static SendPort lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    assert(port != null, "'port' cannot be null.");
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    assert(name != null, "'name' cannot be null.");
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerIncomingCallDisconnected {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_incoming_call_disconnected";

  static SendPort lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    assert(port != null, "'port' cannot be null.");
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    assert(name != null, "'name' cannot be null.");
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerIncomingCallConnectionFailure {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_incoming_call_connection_failure";

  static SendPort lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    assert(port != null, "'port' cannot be null.");
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    assert(name != null, "'name' cannot be null.");
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerIncomingCallQualityWarningsChanged {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_incoming_call_quality_warnings_changed";

  static SendPort lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    assert(port != null, "'port' cannot be null.");
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    assert(name != null, "'name' cannot be null.");
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerIncomingCallReconnecting {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_incoming_call_reconnecting";

  static SendPort lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    assert(port != null, "'port' cannot be null.");
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    assert(name != null, "'name' cannot be null.");
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerIncomingCallReconnected {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_incoming_call_reconnected";

  static SendPort lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    assert(port != null, "'port' cannot be null.");
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    assert(name != null, "'name' cannot be null.");
    return IsolateNameServer.removePortNameMapping(name);
  }
}
