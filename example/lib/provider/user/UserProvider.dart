import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:voice_example/api/StreamBase.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/constant/RoutePaths.dart';
import 'package:voice_example/main.dart';
import 'package:voice_example/provider/common/ps_provider.dart';
import 'package:voice_example/repository/UserRepository.dart';
import 'package:voice_example/socket/SocketIoManager.dart';
import 'package:voice_example/utils/utils.dart';
import 'package:voice_example/viewobject/model/checkDuplicateLogin/CheckDuplicateLogin.dart';
import 'package:voice_example/viewobject/model/login/User.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:voice_example/viewobject/model/onlineStatus/onlineStatusResponse.dart';
import 'package:voice_example/viewobject/model/profile/Profile.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:web_socket_channel/status.dart' as status;

class UserProvider extends Provider {
  UserProvider(
      {@required UserRepository userRepository,
      @required this.valueHolder,
      int limit = 0})
      : super(userRepository, limit) {
    this.userRepository = userRepository;
    isDispose = false;
    streamLoginUser = StreamController<Resources<User>>.broadcast();
    subscriptionLoginUser =
        streamLoginUser.stream.listen((Resources<User> resource) {
      if (resource != null && resource.data != null) {
        _loginUser = resource;
      }

      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    streamUserProfile = StreamController<Resources<Profile>>.broadcast();
    subscriptionUserProfile =
        streamUserProfile.stream.listen((Resources<Profile> resource) {
      if (resource != null && resource.data != null) {
        _userProfile = resource;
      }

      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  UserRepository userRepository;
  ValueHolder valueHolder;

  Resources<User> _loginUser = Resources<User>(Status.NO_ACTION, '', null);
  Resources<CheckDuplicateLogin> _checkDuplicateLoginModel =
      Resources<CheckDuplicateLogin>(Status.NO_ACTION, '', null);

  Resources<User> get loginUser => _loginUser;

  StreamSubscription<Resources<User>> subscriptionLoginUser;
  StreamController<Resources<User>> streamLoginUser;

  Resources<Profile> _userProfile =
      Resources<Profile>(Status.NO_ACTION, '', null);

  Resources<Profile> get userProfile => _userProfile;

  Resources<OnlineStatusResponse> _userOnlineStatus =
      Resources<OnlineStatusResponse>(Status.NO_ACTION, '', null);

  Resources<OnlineStatusResponse> get userOnlineStatus => _userOnlineStatus;

  StreamSubscription<Resources<Profile>> subscriptionUserProfile;
  StreamController<Resources<Profile>> streamUserProfile;

  @override
  void dispose() {
    subscriptionLoginUser.cancel();
    streamLoginUser.close();

    subscriptionUserProfile.cancel();
    streamUserProfile.close();

    isDispose = true;
    super.dispose();
  }

  Future<dynamic> doCheckDuplicateLogin(Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _checkDuplicateLoginModel = await userRepository.doCheckDuplicateLogin(
        jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);

    return _checkDuplicateLoginModel;
  }

  Future<dynamic> doUserLoginApiCall(Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _loginUser = await userRepository.doUserLoginApiCall(
        jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);

    return _loginUser;
  }

  Future<dynamic> getUserProfileDetails() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _userProfile = await userRepository.getUserProfileDetails(
        isConnectedToInternet, Status.PROGRESS_LOADING);

    return _userProfile;
  }

  Future<dynamic> onlineStatus(Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _userOnlineStatus = await userRepository.onlineStatus(
        jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);

    return _userOnlineStatus;
  }

  // void  changeUserStatus(bool status) async
  // {
  //   if (channel != null)
  //   {
  //     FirebaseMessaging fcm=FirebaseMessaging.instance;
  //     if (status)
  //     {
  //       channel.sink.add(SocketIoManager.socketEvents['deviceOnline']);
  //       fcm.subscribeToTopic(Const.NOTIFICATION_CALL_INCOMING_TOPIC);
  //       voiceClient.registerForNotification(
  //         userRepository.getCallAccessToken(),
  //         await fcm.getToken(),
  //       );
  //     }
  //     else
  //     {
  //       channel.sink.add(SocketIoManager.socketEvents['deviceOffline']);
  //       fcm.unsubscribeFromTopic(Const.NOTIFICATION_CALL_INCOMING_TOPIC);
  //       voiceClient.unregisterForNotification(
  //         userRepository.getCallAccessToken(),
  //         await fcm.getToken(),
  //       );
  //     }
  //     replaceIncomingCallNotificationSetting(status);
  //   }
  //   else
  //   {
  //     //need to reinitalize the socket
  //   }
  // }
  //
  // socketLogin(String apiToken,String sessionId)
  // {
  //   String query = 'token='+
  //       apiToken+
  //       "&session="+
  //       sessionId;
  //
  //   var url = Config.socketUrl
  //       +"/loggedIn?$query";
  //
  //   channel = IOWebSocketChannel.connect(
  //       Uri.parse(url),
  //       headers:
  //       {
  //         'Connection': 'upgrade',
  //         'Upgrade': 'websocket'
  //       });
  //   psRepository.replaceIncomingCallNotificationSetting(true);
  //   channel.stream.listen(onData, onError: onError, onDone: onDone);
  // }
  //

  static bool boolIsTokenChanged = false;
  static bool boolIsTokenChangedLoop = false;
  static bool checkLoop = false;
  WebSocketController webSocketController = WebSocketController();

  void onLogout({bool isTokenError = false}) async {
    FirebaseMessaging fcm = FirebaseMessaging.instance;
    if (getVoiceToken() != null) {
      voiceClient.unregisterForNotification(
          getVoiceToken(), await fcm.getToken());
    }
    fcm.deleteToken();
    replaceLoginUserId('');
    if (channel != null) {
      channel.sink.add(SocketIoManager.socketEvents['loggedOut']);
      channel.sink.close(status.goingAway);
      psRepository.replaceIncomingCallNotificationSetting(false);
    }
    // webSocketController.onClose();
    AwesomeNotifications().createdSink.close();
    AwesomeNotifications().displayedSink.close();
    AwesomeNotifications().dismissedSink.close();
    AwesomeNotifications().actionSink.close();
    if (isTokenError) {
      Navigator.of(NavigationService.navigationKey.currentContext)
          .pushNamedAndRemoveUntil(
              RoutePaths.loginView, (Route<dynamic> route) => false);
      boolIsTokenChanged = true;
    } else {
      Navigator.of(NavigationService.navigationKey.currentContext)
          .pushNamedAndRemoveUntil(
              RoutePaths.getStarted, (Route<dynamic> route) => false);
    }
  }
}
