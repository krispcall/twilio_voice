part of flutter_twilio_voice;


const String TAG="VoiceClient Flutter";
class NewMessageNotificationEvent {
  final String channelSid;

  final String messageSid;

  final int messageIndex;

  NewMessageNotificationEvent(this.channelSid, this.messageSid, this.messageIndex)
      : assert(channelSid != null),
        assert(messageSid != null),
        assert(messageIndex != null);
}

class NotificationRegistrationEvent
{
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

class Call {
  final String callSid;

  final String to;

  final String from;

  final bool isOnHold;

  final bool isMuted;

  Call(this.to, this.from, this.isOnHold, this.isMuted, this.callSid);
}
//#endregion

class VoiceClient {

  /// Stream for the notification events.
  StreamSubscription<dynamic> registrationStream;

  /// Stream for the native chat events.
  StreamSubscription<dynamic> handleMessageStream;

  StreamSubscription<dynamic> callOutGoingStream;

  /// Stream for the native chat events.
  StreamSubscription<dynamic> callIncomingStream;

  final String accessToken;

  bool _isReachAbilityEnabled;
  //#endregion

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

  /// Called when an error condition occurs.
  Stream<ErrorInfo> onError;
  //#endregion

  /// Called when client receives a push notification for added to channel event.
  Stream<String> onAddedToChannelNotification;

  /// Called when client receives a push notification for invited to channel event.
  Stream<String> onInvitedToChannelNotification;

  /// Called when client receives a push notification for new message.
  Stream<NewMessageNotificationEvent> onNewMessageNotification;

  /// Called when registering for push notifications fails.
  Stream<ErrorInfo> onNotificationFailed;

  /// Called when client receives a push notification for removed from channel event.
  Stream<String> onRemovedFromChannelNotification;
  //#endregion

  /// Called when token is about to expire soon.
  ///
  /// In response, [VoiceClient] should generate a new token and call [VoiceClient.updateToken] as soon as possible.
  Stream<void> onTokenAboutToExpire;

  Stream<CallInvite> onCallInvite;
  StreamController<CallInvite> _onCallInvite = StreamController<CallInvite>.broadcast();

  Stream<CallInvite> onCancelledCallInvite;
  final StreamController<CallInvite> _onCancelledCallInvite = StreamController<CallInvite>.broadcast();

  //OUtGoing
  Stream<Call> outGoingCallConnectFailure;
  final StreamController<Call> _outGoingCallConnectFailure = StreamController<Call>.broadcast();

  Stream<Call> outGoingCallRinging;
  final StreamController<Call> _outGoingCallRinging = StreamController<Call>.broadcast();

  Stream<Call> outGoingCallConnected;
  final StreamController<Call> _outGoingCallConnected = StreamController<Call>.broadcast();

  Stream<Call> outGoingCallReconnecting;
  final StreamController<Call> _outGoingCallReconnecting = StreamController<Call>.broadcast();

  Stream<Call> outGoingCallReconnected;
  final StreamController<Call> _outGoingCallReconnected = StreamController<Call>.broadcast();

  Stream<Call> outGoingCallDisconnected;
  final StreamController<Call> _outGoingCallDisconnected = StreamController<Call>.broadcast();

  Stream<Call> outGoingCallCallQualityWarningsChanged;
  final StreamController<Call> _outGoingCallCallQualityWarningsChanged = StreamController<Call>.broadcast();

  //Incoming
  Stream<Call> incomingConnectFailure;
  final StreamController<Call> _incomingConnectFailure = StreamController<Call>.broadcast();

  Stream<Call> incomingRinging;
  final StreamController<Call> _incomingRinging = StreamController<Call>.broadcast();

  Stream<Call> incomingConnected;
  final StreamController<Call> _incomingConnected = StreamController<Call>.broadcast();

  Stream<Call> incomingReconnecting;
  final StreamController<Call> _incomingReconnecting = StreamController<Call>.broadcast();

  Stream<Call> incomingReconnected;
  final StreamController<Call> _incomingReconnected = StreamController<Call>.broadcast();

  Stream<Call> incomingDisconnected;
  final StreamController<Call> _incomingDisconnected = StreamController<Call>.broadcast();

  Stream<Call> incomingCallQualityWarningsChanged;
  final StreamController<Call> _incomingCallQualityWarningsChanged = StreamController<Call>.broadcast();


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

  VoiceClient(this.accessToken) : assert(accessToken != null)
  {
    print('this is accesstoekn $accessToken');
    onNotificationRegistered = _onNotificationRegisteredCtrl.stream;
    onNotificationDeregistered = _onNotificationDeregisteredCtrl.stream;

    onCallInvite=_onCallInvite.stream;
    onCancelledCallInvite=_onCancelledCallInvite.stream;

    //OutGoing
    outGoingCallConnectFailure = _outGoingCallConnectFailure.stream;
    outGoingCallRinging = _outGoingCallRinging.stream;
    outGoingCallConnected = _outGoingCallConnected.stream;
    outGoingCallReconnecting = _outGoingCallReconnecting.stream;
    outGoingCallReconnected = _outGoingCallReconnected.stream;
    outGoingCallDisconnected = _outGoingCallDisconnected.stream;
    outGoingCallCallQualityWarningsChanged = _outGoingCallCallQualityWarningsChanged.stream;

    //Incoming
    incomingConnectFailure = _incomingConnectFailure.stream;
    incomingRinging = _incomingRinging.stream;
    incomingConnected = _incomingConnected.stream;
    incomingReconnecting = _incomingReconnecting.stream;
    incomingReconnected = _incomingReconnected.stream;
    incomingDisconnected = _incomingDisconnected.stream;
    incomingCallQualityWarningsChanged = _incomingCallQualityWarningsChanged.stream;

    registrationStream = TwilioVoice.registrationChannel.receiveBroadcastStream(0).listen(_parseNotificationEvents);
    handleMessageStream = TwilioVoice.handleMessageChannel.receiveBroadcastStream(0).listen(_parseHandleMessage);
    callOutGoingStream = TwilioVoice.callOutGoingChannel.receiveBroadcastStream(0).listen(_parseOutGoingCallEvent);
    callIncomingStream = TwilioVoice.callIncomingChannel.receiveBroadcastStream(0).listen(_parseIncomingCallEvents);
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
  Future<void> shutdown() async
  {
    try
    {
      await registrationStream.cancel();
      await handleMessageStream.cancel();
      await callOutGoingStream.cancel();
      await callIncomingStream.cancel();
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

  Future<void> makeCallWithSid(String to,String from,String workspaceSid,String channelSid,String agentId,String token) async {
    try {
      await TwilioVoice._methodChannel.invokeMethod('makeCallWithSid', <String, Object>{'To': to,'from':from,'workspaceSid':workspaceSid, 'channelSid':channelSid, 'agentId':agentId, 'accessToken':token});
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

  Future<void> hold() async {
    try {
      print("this is hold 1");
      await TwilioVoice._methodChannel.invokeMethod('hold');
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

  Future<Map<String, dynamic>> handleMessage(Map<String, dynamic> message) async
  {
    try
    {
      final args = {'notification': message['data']};
      final data = await TwilioVoice._methodChannel.invokeMethod('handleMessage', args);
      return data["result"];
    }
    on PlatformException catch (err)
    {
      throw TwilioVoice._convertException(err);
    }
  }

  Future<void> sendDigit(String digit) async
  {
    try
    {
      await TwilioVoice._methodChannel.invokeMethod('sendDigit', <String, Object>{'digit': digit});
    }
    on PlatformException catch (err)
    {
      throw TwilioVoice._convertException(err);
    }
  }

  Future<bool> registerForNotification(String accessToken,String token) async
  {
    try
    {
      final data = await TwilioVoice._methodChannel.invokeMethod('registerForNotification', <String, Object>{'accessToken':accessToken,'token': token});
      return data["result"];
    }
    on PlatformException catch (err)
    {
      throw TwilioVoice._convertException(err);
    }
  }


  Future<bool> unregisterForNotification(String accessToken,String token) async
  {
    try
    {
      final data = await TwilioVoice._methodChannel.invokeMethod('unregisterForNotification', <String, Object>{'accessToken':accessToken,'token': token});
      return data["result"];
    }
    on PlatformException catch (err)
    {
      throw TwilioVoice._convertException(err);
    }
  }

  void _parseNotificationEvents(dynamic event)
  {
    final String eventName = event['name'];
    print("$TAG => Event '$eventName' => ${event["data"]}, error: ${event["error"]}");
    final data = Map<String, dynamic>.from(event['data']);

    ErrorInfo exception;
    if (event['error'] != null)
    {
      final errorMap = Map<String, dynamic>.from(event['error'] as Map<dynamic, dynamic>);
      exception = ErrorInfo(errorMap['code'] as int, errorMap['message'], errorMap['status'] as int);
    }

    switch (eventName)
    {
      case 'registerForNotification':
        _onNotificationRegisteredCtrl.add(NotificationRegistrationEvent(data['result'], exception));
        break;
      case 'unregisterForNotification':
        _onNotificationDeregisteredCtrl.add(NotificationRegistrationEvent(data['result'], exception));
        break;
      default:
        print("$TAG Notification event '$eventName' not yet implemented");
        break;
    }
  }

  void _parseHandleMessage(dynamic event)
  {
    final String eventName = event['name'];
    print("$TAG => Event '$eventName' => ${event["data"]}, error: ${event["error"]}");
    final data = Map<String, dynamic>.from(event['data']);

    ErrorInfo exception;
    if (event['error'] != null) {
      final errorMap = Map<String, dynamic>.from(event['error'] as Map<dynamic, dynamic>);
      exception = ErrorInfo(errorMap['code'] as int, errorMap['message'], errorMap['status'] as int);
    }

    switch (eventName)
    {
      case 'onCallInvite':
        print("$TAG onCallInvite ${data.toString()}");
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
        print("$TAG onCancelledCallInvite ${data.toString()}");
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
        print("$TAG Notification event '$eventName' not yet implemented");
        break;
    }
  }

  void _parseOutGoingCallEvent(dynamic event)
  {
    final String eventName = event['name'];
    print("$TAG => Event '$eventName' => ${event["data"]}, error: ${event["error"]}");
    final data = Map<String, dynamic>.from(event['data']);

    ErrorInfo exception;
    if (event['error'] != null)
    {
      final errorMap = Map<String, dynamic>.from(event['error'] as Map<dynamic, dynamic>);
      exception = ErrorInfo(errorMap['code'] as int, errorMap['message'], errorMap['status'] as int);
    }

    switch (eventName)
    {
      case 'onConnectFailure':
        print("$TAG onConnectFailure ${data.toString()}");
        var to = data['data']['to'] as String;
        var from = data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] as bool;
        _outGoingCallConnectFailure.add(Call(to,from,isOnHold, isMuted, null));
        break;
      case 'onRinging':
        print("$TAG onRinging ${data.toString()}");
        var to = data['data']['to'] as String;
        var from = data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] as bool;
        var callSid = data['data']['callSid'] as String;

        _outGoingCallRinging.add(Call(to,from,isOnHold, isMuted, callSid));
        break;
      case 'onConnected':
        print("$TAG onConnected ${data.toString()}");
        var to = data['data']['to'] as String;
        var from = data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] as bool;
        _outGoingCallConnected.add(Call(to,from,isOnHold, isMuted, null));
        break;
      case 'onReconnecting':
        print("$TAG onReconnecting ${data.toString()}");
        var to = data['data']['to'] as String;
        var from = data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] as bool;
        _outGoingCallReconnecting.add(Call(to,from,isOnHold, isMuted, null));
        break;
      case 'onReconnected':
        print("$TAG onReconnected ${data.toString()}");
        var to = data['data']['to'] as String;
        var from = data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] as bool;
        _outGoingCallReconnected.add(Call(to,from,isOnHold, isMuted, null));
        break;
      case 'onDisconnected':
        print("this is data ${data.toString()}");
        print("$TAG onDisconnected test ${data.toString()}");
        var to = data['data']['to'] as String;
        var from = data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] as bool;
        _outGoingCallDisconnected.add(Call(to,from,isOnHold, isMuted, null));
        break;
      case 'onCallQualityWarningsChanged':
        print("$TAG onCallQualityWarningsChanged ${data.toString()}");
        var to = data['data']['to'] as String;
        var from = data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] as bool;
        _outGoingCallCallQualityWarningsChanged.add(Call(to,from,isOnHold, isMuted,null));
        break;
      default:
        print("$TAG event '$eventName' not yet implemented");
        break;
    }
  }

  void _parseIncomingCallEvents(dynamic event) {
    final String eventName = event['name'];
    print("$TAG => Event '$eventName' => ${event["data"]}, error: ${event["error"]}");
    final data = Map<String, dynamic>.from(event['data']);

    ErrorInfo exception;
    if (event['error'] != null) {
      final errorMap = Map<String, dynamic>.from(event['error'] as Map<dynamic, dynamic>);
      exception = ErrorInfo(errorMap['code'] as int, errorMap['message'], errorMap['status'] as int);
    }

    switch (eventName)
    {
      case 'onConnectFailure':
        print("$TAG onConnectFailure ${data.toString()}");
        var to = data['data']['to'] as String;
        var from = data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] as bool;
        _incomingConnectFailure.add(Call(to,from,isOnHold, isMuted, null));
        break;
      case 'onRinging':
        print("$TAG onRinging ${data.toString()}");
        var to = data['data']['to'] as String;
        var from = data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] as bool;
        _incomingRinging.add(Call(to,from,isOnHold, isMuted, null));
        break;
      case 'onConnected':
        print("$TAG onConnected ${data.toString()}");
        var to = data['data']['to'] as String;
        var from = data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] as bool;
        _incomingConnected.add(Call(to,from,isOnHold, isMuted, null));
        break;
      case 'onReconnecting':
        print("$TAG onReconnecting ${data.toString()}");
        var to = data['data']['to'] as String;
        var from = data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] as bool;
        _incomingReconnecting.add(Call(to,from,isOnHold, isMuted, null));
        break;
      case 'onReconnected':
        print("$TAG onReconnected ${data.toString()}");
        var to = data['data']['to'] as String;
        var from = data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] as bool;
        _incomingReconnected.add(Call(to,from,isOnHold, isMuted, null));
        break;
      case 'onDisconnected':
        print("$TAG onDisconnected ${data.toString()}");
        var to = data['data']['to'] as String;
        var from = data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] as bool;
        _incomingDisconnected.add(Call(to,from,isOnHold, isMuted, null));
        break;
      case 'onCallQualityWarningsChanged':
        print("$TAG onCallQualityWarningsChanged ${data.toString()}");
        var to = data['data']['to'] as String;
        var from = data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] as bool;
        _incomingCallQualityWarningsChanged.add(Call(to,from,isOnHold, isMuted, null));
        break;
      default:
        print("$TAG event '$eventName' not yet implemented");
        break;
    }
  }
}
