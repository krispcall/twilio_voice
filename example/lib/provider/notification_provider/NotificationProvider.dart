import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:voice_example/api/common/Resources.dart';
import 'package:voice_example/api/common/Status.dart';
import 'package:voice_example/constant/Constants.dart';
import 'package:voice_example/main.dart';
import 'package:voice_example/provider/common/ps_provider.dart';
import 'package:voice_example/repository/Common/NotificationRepository.dart';
import 'package:voice_example/socket/SocketIoManager.dart';
import 'package:voice_example/utils/Utils.dart';
import 'package:voice_example/viewobject/ApiStatus.dart';
import 'package:voice_example/viewobject/common/ValueHolder.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider extends Provider {
  NotificationProvider({
    @required NotificationRepository repo,
    @required this.valueHolder,
    int limit = 0
  }) : super(repo, limit)
  {
    notificationRepository = repo;

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }
  NotificationRepository notificationRepository;
  ValueHolder valueHolder;

  Resources<ApiStatus> _notification = Resources<ApiStatus>(Status.NO_ACTION, '', null);
  Resources<ApiStatus> get user => _notification;

  @override
  void dispose() {
    isDispose = true;
    super.dispose();
  }

  void  replaceIncomingCallNotification(bool status) async
  {
    if (channel != null)
    {
      FirebaseMessaging fcm=FirebaseMessaging.instance;
      if (status)
      {
        channel.sink.add(SocketIoManager.socketEvents['deviceOnline']);
        fcm.subscribeToTopic(Const.NOTIFICATION_CHANNEL_CALL_INCOMING_TOPIC);
        voiceClient.registerForNotification(
          notificationRepository.getCallAccessToken(),
          await fcm.getToken(),
        );
      }
      else
      {
        channel.sink.add(SocketIoManager.socketEvents['deviceOffline']);
        fcm.unsubscribeFromTopic(Const.NOTIFICATION_CHANNEL_CALL_INCOMING_TOPIC);
        voiceClient.unregisterForNotification(
          notificationRepository.getCallAccessToken(),
          await fcm.getToken(),
        );
      }
      replaceIncomingCallNotificationSetting(status);
    }
    else
    {
      //need to reinitalize the socket
    }
  }

  void  replaceSmsNotification(bool status) async
  {
    FirebaseMessaging fcm=FirebaseMessaging.instance;
    if (status)
    {
      fcm.subscribeToTopic(Const.NOTIFICATION_CHANNEL_SMS_TOPIC);
    }
    else
    {
      fcm.unsubscribeFromTopic(Const.NOTIFICATION_CHANNEL_SMS_TOPIC);
    }
    replaceSmsNotificationSetting(status);
  }
}
