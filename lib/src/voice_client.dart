part of flutter_twilio_voice;

//#region VoiceClient events

class NewMessageNotificationEvent {
  final String channelSid;

  final String messageSid;

  final int messageIndex;

  NewMessageNotificationEvent(this.channelSid, this.messageSid, this.messageIndex)
      : assert(channelSid != null),
        assert(messageSid != null),
        assert(messageIndex != null);
}

class NotificationRegistrationEvent {
  final bool isSuccessful;
  final ErrorInfo error;

  NotificationRegistrationEvent(this.isSuccessful, this.error);
}

class CallInvite {
  final String callSid;

  final String to;

  final String from;

  final Map<dynamic, dynamic> customParameters;

  CallInvite(this.callSid, this.to, this.from, this.customParameters);
}
//#endregion

/// Chat client - main entry point for the Chat SDK.
class VoiceClient {
  /// Stream for the native chat events.
  StreamSubscription<dynamic> _handleMessageStream;

  /// Stream for the notification events.
  StreamSubscription<dynamic> _notificationStream;

  //#region Private API properties

  ConnectionState _connectionState;

  final String accessToken;

  bool _isReachAbilityEnabled;
  //#endregion

  //#region Public API properties
  /// [Channels] available to the current client.
  /// Current transport state
  ConnectionState get connectionState {
    return _connectionState;
  }

  /// Get user identity for the current user.
  String get myAccessToken {
    return accessToken;
  }

  /// Get [Users] interface.
  /// Get reachability service status.
  bool get isReachAbilityEnabled{
    return _isReachAbilityEnabled;
  }
  //#endregion

  //#region Channel events


  /// Called when one of the channel of the current user is deleted.


  /// Called when the current user was invited to a channel, channel status is [ChannelStatus.INVITED].

  /// Called when the current user either joined or was added into a channel, channel status is [ChannelStatus.JOINED].

  /// Called when channel synchronization status changed.
  ///
  /// Use [Channel.synchronizationStatus] to obtain new channel status.


  /// Called when the channel is updated.
  ///
  /// [Channel] synchronization updates are delivered via different callback.
  //#endregion

  //#region VoiceClient events
  final StreamController<VoiceClientSynchronizationStatus> _onClientSynchronizationCtrl = StreamController<VoiceClientSynchronizationStatus>.broadcast();

  /// Called when client synchronization status changes.
  Stream<VoiceClientSynchronizationStatus> onClientSynchronization;

  final StreamController<ConnectionState> _onConnectionStateCtrl = StreamController<ConnectionState>.broadcast();

  /// Called when client connnection state has changed.
  Stream<ConnectionState> onConnectionState;

  final StreamController<ErrorInfo> _onErrorCtrl = StreamController<ErrorInfo>.broadcast();

  /// Called when an error condition occurs.
  Stream<ErrorInfo> onError;
  //#endregion

  //#region Notification events
  final StreamController<String> _onAddedToChannelNotificationCtrl = StreamController<String>.broadcast();

  /// Called when client receives a push notification for added to channel event.
  Stream<String> onAddedToChannelNotification;

  final StreamController<String> _onInvitedToChannelNotificationCtrl = StreamController<String>.broadcast();

  /// Called when client receives a push notification for invited to channel event.
  Stream<String> onInvitedToChannelNotification;

  final StreamController<NewMessageNotificationEvent> _onNewMessageNotificationCtrl = StreamController<NewMessageNotificationEvent>.broadcast();

  /// Called when client receives a push notification for new message.
  Stream<NewMessageNotificationEvent> onNewMessageNotification;

  final StreamController<ErrorInfo> _onNotificationFailedCtrl = StreamController<ErrorInfo>.broadcast();

  /// Called when registering for push notifications fails.
  Stream<ErrorInfo> onNotificationFailed;

  final StreamController<String> _onRemovedFromChannelNotificationCtrl = StreamController<String>.broadcast();

  /// Called when client receives a push notification for removed from channel event.
  Stream<String> onRemovedFromChannelNotification;
  //#endregion

  //#region Token events
  final StreamController<void> _onTokenAboutToExpireCtrl = StreamController<void>.broadcast();

  /// Called when token is about to expire soon.
  ///
  /// In response, [VoiceClient] should generate a new token and call [VoiceClient.updateToken] as soon as possible.
  Stream<void> onTokenAboutToExpire;

  final StreamController<void> _onTokenExpiredCtrl = StreamController<void>.broadcast();

  Stream<CallInvite> onCallInvite;

  final StreamController<CallInvite> _onCallInvite = StreamController<CallInvite>.broadcast();

  Stream<CallInvite> onCancelledCallInvite;

  final StreamController<CallInvite> _onCancelledCallInvite = StreamController<CallInvite>.broadcast();

  /// Called when token has expired.
  ///
  /// In response, [VoiceClient] should generate a new token and call [VoiceClient.updateToken] as soon as possible.
  Stream<void> onTokenExpired;
  //#endregion

  //#region User events

  /// Called when a user is subscribed to and will receive realtime state updates.


  /// Called when a user is unsubscribed from and will not receive realtime state updates anymore.


  /// Called when user info is updated for currently loaded users.

  final StreamController<NotificationRegistrationEvent> _onNotificationRegisteredCtrl = StreamController<NotificationRegistrationEvent>.broadcast();

  /// Called when attempt to register device for notifications has completed.
  Stream<NotificationRegistrationEvent> onNotificationRegistered;

  final StreamController<NotificationRegistrationEvent> _onNotificationDeregisteredCtrl = StreamController<NotificationRegistrationEvent>.broadcast();

  /// Called when attempt to register device for notifications has completed.
  Stream<NotificationRegistrationEvent> onNotificationDeregistered;
  //#endregion

  VoiceClient(this.accessToken) : assert(accessToken != null) {
    onClientSynchronization = _onClientSynchronizationCtrl.stream;
    onConnectionState = _onConnectionStateCtrl.stream;
    onError = _onErrorCtrl.stream;
    onAddedToChannelNotification = _onAddedToChannelNotificationCtrl.stream;
    onInvitedToChannelNotification = _onInvitedToChannelNotificationCtrl.stream;
    onNewMessageNotification = _onNewMessageNotificationCtrl.stream;
    onNotificationFailed = _onNotificationFailedCtrl.stream;
    onRemovedFromChannelNotification = _onRemovedFromChannelNotificationCtrl.stream;
    onTokenAboutToExpire = _onTokenAboutToExpireCtrl.stream;
    onTokenExpired = _onTokenExpiredCtrl.stream;

    onCallInvite = _onCallInvite.stream;
    onCancelledCallInvite = _onCancelledCallInvite.stream;

    onNotificationRegistered = _onNotificationRegisteredCtrl.stream;
    onNotificationDeregistered = _onNotificationDeregisteredCtrl.stream;
    onNotificationFailed = _onNotificationFailedCtrl.stream;

    _handleMessageStream = TwilioVoice._handleMessageChannel.receiveBroadcastStream(0).listen(_parseHandleMessage);
    _notificationStream = TwilioVoice._notificationChannel.receiveBroadcastStream(0).listen(_parseNotificationEvents);
  }

  /// Construct from a map.
  factory VoiceClient._fromMap(Map<String, dynamic> map)
  {
    var chatClient = VoiceClient(map['accessToken']);
    return chatClient;
  }

  //#region Public API methods
  /// Method to update the authentication token for this client.
  Future<void> updateToken(String token) async {
    try {
      return await TwilioVoice._methodChannel.invokeMethod('VoiceClient#updateToken', <String, Object>{'token': token});
    } on PlatformException catch (err) {
      throw TwilioVoice._convertException(err);
    }
  }

  /// Cleanly shuts down the messaging client when you are done with it.
  ///
  /// It will dispose() the client after shutdown, so it could not be reused.
  Future<void> shutdown() async {
    try
    {
      await _notificationStream.cancel();
      await _handleMessageStream.cancel();
      await _onClientSynchronizationCtrl.close();
      TwilioVoice.voiceClient = null;
      return await TwilioVoice._methodChannel.invokeMethod('VoiceClient#shutdown', null);
    } on PlatformException catch (err) {
      throw TwilioVoice._convertException(err);
    }
  }

  Future<void> makeCall(String accessToken,String from,String to,String displayName) async {
    try {
      await TwilioVoice._methodChannel.invokeMethod('makeCall', <String, Object>{'To': to,'from':from,'accessToken':accessToken,'displayName':displayName});
    } on PlatformException catch (err) {
      throw TwilioVoice._convertException(err);
    }
  }

  Future<void> rejectCall() async {
    try {
      await TwilioVoice._methodChannel.invokeMethod('rejectCall');
    } on PlatformException catch (err) {
      throw TwilioVoice._convertException(err);
    }
  }

  Future<void> disConnect() async {
    try {
      await TwilioVoice._methodChannel.invokeMethod('disConnect');
    } on PlatformException catch (err) {
      throw TwilioVoice._convertException(err);
    }
  }

  Future<void> mute() async {
    try {
      await TwilioVoice._methodChannel.invokeMethod('mute');
    } on PlatformException catch (err) {
      throw TwilioVoice._convertException(err);
    }
  }

  Future<void> acceptCall() async {
    try {
      await TwilioVoice._methodChannel.invokeMethod('acceptCall');
    } on PlatformException catch (err) {
      throw TwilioVoice._convertException(err);
    }
  }

  Future<void> handleMessage(Map<String, dynamic> message) async
  {
    try
    {
      final args = {'notification': message['data']};
      await TwilioVoice._methodChannel.invokeMethod('handleMessage', args);
    }
    on PlatformException catch (err)
    {
      throw TwilioVoice._convertException(err);
    }
  }

  /// Registers for push notifications. Uses APNs on iOS and FCM on Android.
  ///
  /// Token is only used on Android. iOS implementation retrieves APNs token itself.
  ///
  /// Twilio iOS SDK handles receiving messages when app is in the background and displaying
  /// notifications.
  Future<void> registerForNotification(String accessToken,String token) async {
    try {
      await TwilioVoice._methodChannel.invokeMethod('registerForNotification', <String, Object>{'accessToken':accessToken,'token': token});
    } on PlatformException catch (err) {
      throw TwilioVoice._convertException(err);
    }
  }

  /// Unregisters for push notifications.  Uses APNs on iOS and FCM on Android.
  ///
  /// Token is only used on Android. iOS implementation retrieves APNs token itself.
  Future<void> unregisterForNotification(String accessToken,String token) async {
    try {
      await TwilioVoice._methodChannel.invokeMethod('unregisterForNotification', <String, Object>{'accessToken':accessToken,'token': token});
    } on PlatformException catch (err) {
      throw TwilioVoice._convertException(err);
    }
  }
  //#endregion

  /// Update properties from a map.

  /// Parse native chat client events to the right event streams.
  void _parseEvents(dynamic event)
  {
    final String eventName = event['name'];
    TwilioVoice._log("VoiceClient => Event '$eventName' => ${event["data"]}, error: ${event["error"]}");
    final data = Map<String, dynamic>.from(event['data'] ?? {});

    if (data['voiceClient'] != null) {
      final chatClientMap = Map<String, dynamic>.from(data['chatClient']);
    }

    ErrorInfo exception;
    if (event['error'] != null) {
      final errorMap = Map<String, dynamic>.from(event['error'] as Map<dynamic, dynamic>);
      exception = ErrorInfo(errorMap['code'] as int, errorMap['message'], errorMap['status'] as int);
    }

    Map<String, dynamic> channelMap;
    if (data['channel'] != null) {
      channelMap = Map<String, dynamic>.from(data['channel'] as Map<dynamic, dynamic>);
    }

    Map<String, dynamic> userMap;
    if (data['user'] != null) {
      userMap = Map<String, dynamic>.from(data['user'] as Map<dynamic, dynamic>);
    }

    var channelSid = data['channelSid'] as String;

    dynamic reason;

    switch (eventName)
    {
      case 'addedToChannelNotification':
        assert(channelSid != null);
        _onAddedToChannelNotificationCtrl.add(channelSid);
        break;
      case 'connectionStateChange':
        var connectionState = EnumToString.fromString(ConnectionState.values, data['connectionState']);
        assert(connectionState != null);
        _connectionState = connectionState;
        _onConnectionStateCtrl.add(connectionState);
        break;
      case 'error':
        assert(exception != null);
        _onErrorCtrl.add(exception);
        break;
      case 'invitedToChannelNotification':
        assert(channelSid != null);
        _onInvitedToChannelNotificationCtrl.add(channelSid);
        break;
      case 'newMessageNotification':
        var messageSid = data['messageSid'] as String;
        var messageIndex = data['messageIndex'] as int;
        assert(channelSid != null);
        assert(messageSid != null);
        assert(messageIndex != null);
        _onNewMessageNotificationCtrl.add(NewMessageNotificationEvent(channelSid, messageSid, messageIndex));
        break;
      case 'notificationFailed':
        assert(exception != null);
        _onNotificationFailedCtrl.add(exception);
        break;
      case 'removedFromChannelNotification':
        assert(channelSid != null);
        _onRemovedFromChannelNotificationCtrl.add(channelSid);
        break;
      case 'tokenAboutToExpire':
        _onTokenAboutToExpireCtrl.add(null);
        break;
      case 'tokenExpired':
        _onTokenExpiredCtrl.add(null);
        break;
      default:
        TwilioVoice._log("Event '$eventName' not yet implemented");
        break;
    }
  }

  /// Parse native chat client events to the right event streams.
  void _parseNotificationEvents(dynamic event) {
    final String eventName = event['name'];
    TwilioVoice._log("VoiceClient => Event '$eventName' => ${event["data"]}, error: ${event["error"]}");
    final data = Map<String, dynamic>.from(event['data']);

    ErrorInfo exception;
    if (event['error'] != null) {
      final errorMap = Map<String, dynamic>.from(event['error'] as Map<dynamic, dynamic>);
      exception = ErrorInfo(errorMap['code'] as int, errorMap['message'], errorMap['status'] as int);
    }

    switch (eventName) {
      case 'registerForNotification':
        _onNotificationRegisteredCtrl.add(NotificationRegistrationEvent(data['result'], exception));
        break;
      case 'unregisterForNotification':
        _onNotificationDeregisteredCtrl.add(NotificationRegistrationEvent(data['result'], exception));
        break;
      default:
        TwilioVoice._log("Notification event '$eventName' not yet implemented");
        break;
    }
  }

  void _parseHandleMessage(dynamic event) {
    final String eventName = event['name'];
    TwilioVoice._log("VoiceClient => Event '$eventName' => ${event["data"]}, error: ${event["error"]}");
    final data = Map<String, dynamic>.from(event['data']);

    ErrorInfo exception;
    if (event['error'] != null) {
      final errorMap = Map<String, dynamic>.from(event['error'] as Map<dynamic, dynamic>);
      exception = ErrorInfo(errorMap['code'] as int, errorMap['message'], errorMap['status'] as int);
    }

    switch (eventName) {
      case 'onCallInvite':
        print("onCallInvite ${data.toString()}");
        var callSid = data['data']['callSid'] as String;
        var to = data['data']['to'] as String;
        var from = data['data']['from'] as String;
        var customParameters = data['data']['customParameters'] as Map<dynamic, dynamic>;
        assert(callSid != null);
        assert(to != null);
        assert(from != null);
        assert(customParameters != null);
        _onCallInvite.add(CallInvite(callSid,to,from,customParameters));
        break;
      case 'onCancelledCallInvite':
        print("onCancelledCallInvite ${data.toString()}");
        var callSid = data['data']['callSid'] as String;
        var to = data['data']['to'] as String;
        var from = data['data']['from'] as String;
        var customParameters = data['data']['customParameters'] as Map<dynamic, dynamic>;
        assert(callSid != null);
        assert(to != null);
        assert(from != null);
        assert(customParameters != null);
        _onCancelledCallInvite.add(CallInvite(callSid,to,from,customParameters));
        break;

      default:
        TwilioVoice._log("Notification event '$eventName' not yet implemented");
        break;
    }
  }
}
