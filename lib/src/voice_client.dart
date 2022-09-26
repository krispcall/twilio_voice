part of flutter_twilio_voice;

const String TAG = "VoiceClient Flutter";

class NewMessageNotificationEvent {
  final String channelSid;

  final String messageSid;

  final int messageIndex;

  NewMessageNotificationEvent(
      this.channelSid, this.messageSid, this.messageIndex)
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
  final String? callSid;

  final String? to;

  final String? from;

  final Map<dynamic, dynamic>? customParameters;

  final Map<dynamic, dynamic>? channelInfo;

  final Map<dynamic, dynamic>? error;

  CallInvite(this.callSid, this.to, this.from, this.customParameters,
      this.channelInfo, this.error);
}

class AnswerCall {
  final String answerCall;

  AnswerCall(this.answerCall);
}

class Call {
  final String? callSid;

  final String? to;

  final String? from;

  final bool? isOnHold;

  final bool? isMuted;

  final Map<dynamic, dynamic>? error;

  Call(this.to, this.from, this.isOnHold, this.isMuted, this.callSid,
      this.error);
}
//#endregion

class VoiceClient {
  var customParameters;

  String? tempChannelInfo;

  bool _isOnCall = false;

  /// Stream for the notification events.
  StreamSubscription<dynamic>? registrationStream;

  /// Stream for the native chat events.
  StreamSubscription<dynamic>? handleMessageStream;

  StreamSubscription<dynamic>? callOutGoingStream;

  /// Stream for the native chat events.
  StreamSubscription<dynamic>? callIncomingStream;

  final String accessToken;

  bool? _isReachAbilityEnabled;
  //#endregion

  /// Get user identity for the current user.
  String get myAccessToken {
    return accessToken;
  }

  bool get isOnCall {
    return _isOnCall;
  }

  /// Get [Users] interface.
  /// Get reachability service status.
  bool get isReachAbilityEnabled {
    return _isReachAbilityEnabled!;
  }
  //#endregion

  //#region Channel events

  /// Called when one of the channel of the current user is deleted.

  /// Called when the current user was invited to a channel, channel status is [ChannelStatus.INVITED].

  /// Called when the current user either joined or was added into a channel, channel status is [ChannelStatus.JOINED].

  /// Called when channel synchronization status changed.
  ///+
  /// Use [Channel.synchronizationStatus] to obtain new channel status.

  /// Called when the channel is updated.
  ///
  /// [Channel] synchronization updates are delivered via different callback.
  //#endregion

  /// Called when an error condition occurs.
  Stream<ErrorInfo>? onError;
  //#endregion

  /// Called when client receives a push notification for added to channel event.
  Stream<String>? onAddedToChannelNotification;

  /// Called when client receives a push notification for invited to channel event.
  Stream<String>? onInvitedToChannelNotification;

  /// Called when client receives a push notification for new message.
  Stream<NewMessageNotificationEvent>? onNewMessageNotification;

  /// Called when registering for push notifications fails.
  Stream<ErrorInfo>? onNotificationFailed;

  /// Called when client receives a push notification for removed from channel event.
  Stream<String>? onRemovedFromChannelNotification;
  //#endregion

  /// Called when token is about to expire soon.
  ///
  /// In response, [VoiceClient] should generate a new token and call [VoiceClient.updateToken] as soon as possible.
  Stream<void>? onTokenAboutToExpire;

  Stream<CallInvite>? onCallInvite;
  StreamController<CallInvite> _onCallInvite =
      StreamController<CallInvite>.broadcast();

  Stream<CallInvite>? onCancelledCallInvite;
  final StreamController<CallInvite> _onCancelledCallInvite =
      StreamController<CallInvite>.broadcast();

  Stream<CallInvite>? onAnswerCall;
  final StreamController<CallInvite> _onAnswerCall =
      StreamController<CallInvite>.broadcast();

  //OUtGoing
  Stream<Call>? outGoingCallConnectFailure;
  final StreamController<Call> _outGoingCallConnectFailure =
      StreamController<Call>.broadcast();

  Stream<Call>? outGoingCallRinging;
  final StreamController<Call> _outGoingCallRinging =
      StreamController<Call>.broadcast();

  Stream<Call>? outGoingCallConnected;
  final StreamController<Call> _outGoingCallConnected =
      StreamController<Call>.broadcast();

  Stream<Call>? outGoingCallReconnecting;
  final StreamController<Call> _outGoingCallReconnecting =
      StreamController<Call>.broadcast();

  Stream<Call>? outGoingCallReconnected;
  final StreamController<Call> _outGoingCallReconnected =
      StreamController<Call>.broadcast();

  Stream<Call>? outGoingCallDisconnected;
  final StreamController<Call> _outGoingCallDisconnected =
      StreamController<Call>.broadcast();

  Stream<Call>? outGoingCallCallQualityWarningsChanged;
  final StreamController<Call> _outGoingCallCallQualityWarningsChanged =
      StreamController<Call>.broadcast();

  //Incoming
  Stream<CallInvite>? incomingConnectFailure;
  final StreamController<CallInvite> _incomingConnectFailure =
      StreamController<CallInvite>.broadcast();

  Stream<CallInvite>? incomingRinging;
  final StreamController<CallInvite> _incomingRinging =
      StreamController<CallInvite>.broadcast();

  Stream<CallInvite>? incomingConnected;
  final StreamController<CallInvite> _incomingConnected =
      StreamController<CallInvite>.broadcast();

  Stream<CallInvite>? incomingReconnecting;
  final StreamController<CallInvite> _incomingReconnecting =
      StreamController<CallInvite>.broadcast();

  Stream<CallInvite>? incomingReconnected;
  final StreamController<CallInvite> _incomingReconnected =
      StreamController<CallInvite>.broadcast();

  Stream<CallInvite>? incomingDisconnected;
  final StreamController<CallInvite> _incomingDisconnected =
      StreamController<CallInvite>.broadcast();

  Stream<CallInvite>? incomingCallQualityWarningsChanged;
  final StreamController<CallInvite> _incomingCallQualityWarningsChanged =
      StreamController<CallInvite>.broadcast();

  /// Called when token has expired.
  ///
  /// In response, [VoiceClient] should generate a new token and call [VoiceClient.updateToken] as soon as possible.
  Stream<void>? onTokenExpired;
  //#endregion

  //#region User events

  /// Called when a user is subscribed to and will receive realtime state updates.

  /// Called when a user is unsubscribed from and will not receive realtime state updates anymore.

  /// Called when user info is updated for currently loaded users.

  final StreamController<NotificationRegistrationEvent>
      _onNotificationRegisteredCtrl =
      StreamController<NotificationRegistrationEvent>.broadcast();

  /// Called when attempt to register device for notifications has completed.
  Stream<NotificationRegistrationEvent>? onNotificationRegistered;

  final StreamController<NotificationRegistrationEvent>
      _onNotificationDeregisteredCtrl =
      StreamController<NotificationRegistrationEvent>.broadcast();

  /// Called when attempt to register device for notifications has completed.
  Stream<NotificationRegistrationEvent>? onNotificationDeregistered;
  //#endregion

  VoiceClient(this.accessToken) : assert(accessToken != null) {
    onNotificationRegistered = _onNotificationRegisteredCtrl.stream;
    onNotificationDeregistered = _onNotificationDeregisteredCtrl.stream;

    onCallInvite = _onCallInvite.stream;
    onCancelledCallInvite = _onCancelledCallInvite.stream;
    onAnswerCall = _onAnswerCall.stream;

    //OutGoing
    outGoingCallConnectFailure = _outGoingCallConnectFailure.stream;
    outGoingCallRinging = _outGoingCallRinging.stream;
    outGoingCallConnected = _outGoingCallConnected.stream;
    outGoingCallReconnecting = _outGoingCallReconnecting.stream;
    outGoingCallReconnected = _outGoingCallReconnected.stream;
    outGoingCallDisconnected = _outGoingCallDisconnected.stream;
    outGoingCallCallQualityWarningsChanged =
        _outGoingCallCallQualityWarningsChanged.stream;

    //Incoming
    incomingConnectFailure = _incomingConnectFailure.stream;
    incomingRinging = _incomingRinging.stream;
    incomingConnected = _incomingConnected.stream;
    incomingReconnecting = _incomingReconnecting.stream;
    incomingReconnected = _incomingReconnected.stream;
    incomingDisconnected = _incomingDisconnected.stream;
    incomingCallQualityWarningsChanged =
        _incomingCallQualityWarningsChanged.stream;

    registrationStream = TwilioVoice.registrationChannel
        .receiveBroadcastStream(0)
        .listen(_parseNotificationEvents);
    handleMessageStream = TwilioVoice.handleMessageChannel
        .receiveBroadcastStream(0)
        .listen(_parseHandleMessage);
    callOutGoingStream = TwilioVoice.callOutGoingChannel
        .receiveBroadcastStream(0)
        .listen(_parseOutGoingCallEvent);
    callIncomingStream = TwilioVoice.callIncomingChannel
        .receiveBroadcastStream(0)
        .listen(_parseIncomingCallEvents);
  }

  /// Construct from a map.
  factory VoiceClient._fromMap(Map<String, dynamic> map) {
    var chatClient = VoiceClient(map['accessToken']);
    return chatClient;
  }

  //#region Public API methods
  /// Method to update the authentication token for this client.
  Future<void> updateToken(String token) async {
    try {
      return await TwilioVoice._methodChannel.invokeMethod(
          'VoiceClient#updateToken', <String, Object>{'token': token});
    } on PlatformException catch (err) {
      throw TwilioVoice._convertException(err);
    }
  }

  /// Cleanly shuts down the messaging client when you are done with it.
  ///
  /// It will dispose() the client after shutdown, so it could not be reused.
  Future<void> shutdown() async {
    try {
      await registrationStream?.cancel();
      await handleMessageStream?.cancel();
      await callOutGoingStream?.cancel();
      await callIncomingStream?.cancel();
      TwilioVoice.voiceClient = null;
      return await TwilioVoice._methodChannel
          .invokeMethod('VoiceClient#shutdown', null);
    } on PlatformException catch (err) {
      throw TwilioVoice._convertException(err);
    }
  }

  Future<void> makeCall(
      String accessToken, String from, String to, String displayName) async {
    try {
      await TwilioVoice._methodChannel.invokeMethod(
          'makeCall', <String, Object>{
        'To': to,
        'from': from,
        'accessToken': accessToken,
        'displayName': displayName
      });
    } on PlatformException catch (err) {
      throw TwilioVoice._convertException(err);
    }
  }

  Future<void> makeCallWithSid(String to, String from, String workspaceSid,
      String channelSid, String agentId, String token) async {
    try {
      await TwilioVoice._methodChannel
          .invokeMethod('makeCallWithSid', <String, Object>{
        'To': to,
        'from': from,
        'workspaceSid': workspaceSid,
        'channelSid': channelSid,
        'agentId': agentId,
        'accessToken': token
      });
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

  Future<dynamic> handleMessage(Map<String, dynamic> message) async {
    try {
      final args = {'notification': message['data']};
      final data =
          await TwilioVoice._methodChannel.invokeMethod('handleMessage', args);
      return data["result"];
    } on PlatformException catch (err) {
      throw TwilioVoice._convertException(err);
    }
  }

  Future<void> sendDigit(String digit) async {
    try {
      await TwilioVoice._methodChannel
          .invokeMethod('sendDigit', <String, Object>{'digit': digit});
    } on PlatformException catch (err) {
      throw TwilioVoice._convertException(err);
    }
  }

  Future<bool> registerForNotification(String accessToken, String token) async {
    try {
      final data = await TwilioVoice._methodChannel.invokeMethod(
          'registerForNotification',
          <String, Object>{'accessToken': accessToken, 'token': token});
      print("this is register for notification data $data");
      return data["result"];
    } on PlatformException catch (err) {
      throw TwilioVoice._convertException(err);
    }
  }

  Future<bool> unregisterForNotification(
      String accessToken, String token) async {
    try {
      final data = await TwilioVoice._methodChannel.invokeMethod(
          'unregisterForNotification',
          <String, Object>{'accessToken': accessToken, 'token': token});
      return data["result"];
    } on PlatformException catch (err) {
      throw TwilioVoice._convertException(err);
    }
  }

  void _parseNotificationEvents(dynamic event) {
    final String eventName = event['name'];
    final data = Map<String, dynamic>.from(event['data']);

    ErrorInfo exception = ErrorInfo(200, "", 200);
    if (event['error'] != null) {
      final errorMap =
          Map<String, dynamic>.from(event['error'] as Map<dynamic, dynamic>);
      exception = ErrorInfo(errorMap['code'] as int, errorMap['message'],
          errorMap['status'] == null ? 0 : errorMap['status'] as int);
    }

    switch (eventName) {
      case 'registerForNotification':
        _onNotificationRegisteredCtrl
            .add(NotificationRegistrationEvent(data['result'], exception));
        break;
      case 'unregisterForNotification':
        _onNotificationDeregisteredCtrl
            .add(NotificationRegistrationEvent(data['result'], exception));
        break;
      default:
        break;
    }
  }

  void _parseHandleMessage(dynamic event) {
    final String eventName = event['name'];
    final data = Map<String, dynamic>.from(event['data']);

    ErrorInfo exception;
    if (event['error'] != null) {
      final errorMap =
          Map<String, dynamic>.from(event['error'] as Map<dynamic, dynamic>);
      exception = ErrorInfo(errorMap['code'] as int, errorMap['message'],
          errorMap['status'] == null ? 0 : errorMap['status'] as int);
    }

    switch (eventName) {
      case 'onCallInvite':
        _isOnCall = true;
        print("this is data onCallInvite $data");
        var callSid = Platform.isIOS
            ? data['data']['callSid'] == null
                ? null
                : data['data']['callSid'] as String
            : data['data']['twi_call_sid'] == null
                ? null
                : data['data']['twi_call_sid'] as String;
        var to = Platform.isIOS
            ? data['data']['to'] == null
                ? null
                : data['data']['to'] as String
            : data['data']['twi_to'] == null
                ? null
                : data['data']['twi_to'] as String;
        var from = Platform.isIOS
            ? data['data']['customParameters']['from'] == null
                ? null
                : data['data']['customParameters']['from'] as String
            : data['data']['twi_from'] == null
                ? null
                : data['data']['twi_from'] as String;
        var error = event['error'] != null ? event["error"] : null;
        this.customParameters =
            data['data']['customParameters'] as Map<dynamic, dynamic>;

        tempChannelInfo = this.customParameters['channel_info'] as String;
        tempChannelInfo = tempChannelInfo?.replaceAll("{'", "{\"");
        tempChannelInfo = tempChannelInfo?.replaceAll("':", "\":");
        tempChannelInfo = tempChannelInfo?.replaceAll(": '", ": \"");
        tempChannelInfo = tempChannelInfo?.replaceAll("',", "\",");
        tempChannelInfo = tempChannelInfo?.replaceAll(", '", ", \"");
        tempChannelInfo = tempChannelInfo?.replaceAll("'}", "\"}");
        tempChannelInfo = tempChannelInfo?.replaceAll("None", "null");
        print("this is channel info ${tempChannelInfo}");
        var channelInfo =
            (json.decode(tempChannelInfo!)) as Map<dynamic, dynamic>;
        assert(callSid != null);
        assert(to != null);
        assert(from != null);
        assert(customParameters != null);
        assert(channelInfo != null);
        _onCallInvite.add(CallInvite(
            callSid, to, from, customParameters, channelInfo, error));
        break;
      case 'onCancelledCallInvite':
        _isOnCall = false;
        print("this is data onCancelledCallInvite $data");
        var callSid = Platform.isIOS
            ? data['data']['callSid'] == null
                ? null
                : data['data']['callSid'] as String
            : data['data']['twi_call_sid'] == null
                ? null
                : data['data']['twi_call_sid'] as String;
        var to = Platform.isIOS
            ? data['data']['to'] == null
                ? null
                : data['data']['to'] as String
            : data['data']['twi_to'] == null
                ? null
                : data['data']['twi_to'] as String;
        var from = Platform.isIOS
            ? data['data']['from'] == null
                ? null
                : data['data']['from'] as String
            : data['data']['twi_from'] == null
                ? null
                : data['data']['twi_from'] as String;
        var customParameters = data['data']['customParameters'] == null
            ? null
            : data['data']['customParameters'] as Map<dynamic, dynamic>;
        var error = event['error'] != null ? event["error"] : null;
        tempChannelInfo = customParameters!['channel_info'] == null
            ? null
            : customParameters['channel_info'] as String;
        tempChannelInfo = tempChannelInfo?.replaceAll("{'", "{\"");
        tempChannelInfo = tempChannelInfo?.replaceAll("':", "\":");
        tempChannelInfo = tempChannelInfo?.replaceAll(": '", ": \"");
        tempChannelInfo = tempChannelInfo?.replaceAll("',", "\",");
        tempChannelInfo = tempChannelInfo?.replaceAll(", '", ", \"");
        tempChannelInfo = tempChannelInfo?.replaceAll("'}", "\"}");
        tempChannelInfo = tempChannelInfo?.replaceAll("None", "null");
        print("this is channel info ${tempChannelInfo}");
        var channelInfo =
            (json.decode(tempChannelInfo!)) as Map<dynamic, dynamic>;
        assert(callSid != null);
        assert(to != null);
        assert(from != null);
        assert(customParameters != null);
        assert(channelInfo != null);
        _onCancelledCallInvite.add(CallInvite(
            callSid, to, from, customParameters, channelInfo, error));
        tempChannelInfo = "";
        break;
      case 'onAnswerCall':
        _isOnCall = true;
        print("this is data onAnswerCall $data");
        var callSid = Platform.isIOS
            ? data['data']['callSid'] == null
                ? null
                : data['data']['callSid'] as String
            : data['data']['twi_call_sid'] == null
                ? null
                : data['data']['twi_call_sid'] as String;
        var to = Platform.isIOS
            ? data['data']['to'] == null
                ? null
                : data['data']['to'] as String
            : data['data']['twi_to'] == null
                ? null
                : data['data']['twi_to'] as String;
        var from = Platform.isIOS
            ? data['data']['from'] == null
                ? null
                : data['data']['from'] as String
            : data['data']['twi_from'] == null
                ? null
                : data['data']['twi_from'] as String;
        var customParameters = data['data']['customParameters'] == null
            ? null
            : data['data']['customParameters'] as Map<dynamic, dynamic>;
        var error = event['error'] != null ? event["error"] : null;
        tempChannelInfo =
            data['data']['customParameters']['channel_info'] == null
                ? null
                : data['data']['customParameters']['channel_info'] as String;
        tempChannelInfo = tempChannelInfo?.replaceAll("{'", "{\"");
        tempChannelInfo = tempChannelInfo?.replaceAll("':", "\":");
        tempChannelInfo = tempChannelInfo?.replaceAll(": '", ": \"");
        tempChannelInfo = tempChannelInfo?.replaceAll("',", "\",");
        tempChannelInfo = tempChannelInfo?.replaceAll(", '", ", \"");
        tempChannelInfo = tempChannelInfo?.replaceAll("'}", "\"}");
        tempChannelInfo = tempChannelInfo?.replaceAll("None", "null");
        print("this is channel info ${tempChannelInfo}");
        var channelInfo =
            (json.decode(tempChannelInfo!)) as Map<dynamic, dynamic>;
        assert(callSid != null);
        assert(to != null);
        assert(from != null);
        assert(customParameters != null);
        assert(channelInfo != null);
        _onAnswerCall.add(CallInvite(
            callSid, to, from, customParameters, channelInfo, error));
        // print("this is data onAnswerCall $data");
        // _onAnswerCall.add(data.toString());
        break;

      default:
        break;
    }
  }

  void _parseOutGoingCallEvent(dynamic event) {
    final String eventName = event['name'];
    final data = Map<String, dynamic>.from(event['data']);

    ErrorInfo exception;
    if (event['error'] != null) {
      final errorMap =
          Map<String, dynamic>.from(event['error'] as Map<dynamic, dynamic>);
      exception = ErrorInfo(errorMap['code'] as int, errorMap['message'] ?? "",
          errorMap['status'] == null ? 0 : errorMap['status'] as int);
    }

    switch (eventName) {
      case 'onConnectFailure':
        print("this is data onConnectFailure $data");
        var to =
            data['data']['to'] == null ? null : data['data']['to'] as String;
        var from = data['data']['from'] == null
            ? null
            : data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] == null
            ? null
            : data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] == null
            ? null
            : data['data']['isMuted'] as bool;
        var error = event['error'] != null ? event["error"] : null;
        _outGoingCallConnectFailure
            .add(Call(to, from, isOnHold, isMuted, null, error));
        break;
      case 'onRinging':
        print("this is data onRinging $data");
        var to =
            data['data']['to'] == null ? null : data['data']['to'] as String;
        var from = data['data']['from'] == null
            ? null
            : data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] == null
            ? null
            : data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] == null
            ? null
            : data['data']['isMuted'] as bool;
        var callSid = data['data']['callSid'] == null
            ? null
            : data['data']['callSid'] as String;
        var error = event['error'] != null ? event["error"] : null;

        _outGoingCallRinging
            .add(Call(to, from, isOnHold, isMuted, callSid, error));
        break;
      case 'onConnected':
        print("this is data onConnected $data");
        var to =
            data['data']['to'] == null ? null : data['data']['to'] as String;
        var from = data['data']['from'] == null
            ? null
            : data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] == null
            ? null
            : data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] == null
            ? null
            : data['data']['isMuted'] as bool;
        var error = event['error'] != null ? event["error"] : null;
        _outGoingCallConnected
            .add(Call(to, from, isOnHold, isMuted, null, error));
        break;
      case 'onReconnecting':
        print("this is data onReconnecting $data");
        var to =
            data['data']['to'] == null ? null : data['data']['to'] as String;
        var from = data['data']['from'] == null
            ? null
            : data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] == null
            ? null
            : data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] == null
            ? null
            : data['data']['isMuted'] as bool;
        var error = event['error'] != null ? event["error"] : null;
        _outGoingCallReconnecting
            .add(Call(to, from, isOnHold, isMuted, null, error));
        break;
      case 'onReconnected':
        print("this is data onReconnected $data");
        var to =
            data['data']['to'] == null ? null : data['data']['to'] as String;
        var from = data['data']['from'] == null
            ? null
            : data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] == null
            ? null
            : data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] == null
            ? null
            : data['data']['isMuted'] as bool;
        var error = event['error'] != null ? event["error"] : null;
        _outGoingCallReconnected
            .add(Call(to, from, isOnHold, isMuted, null, error));
        break;
      case 'onDisconnected':
        _isOnCall = false;
        print("this is data onDisconnected $data");
        var to =
            data['data']['to'] == null ? null : data['data']['to'] as String;
        var from = data['data']['from'] == null
            ? null
            : data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] == null
            ? null
            : data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] == null
            ? null
            : data['data']['isMuted'] as bool;
        var error = event['error'] != null ? event["error"] : null;
        _outGoingCallDisconnected
            .add(Call(to, from, isOnHold, isMuted, null, error));
        tempChannelInfo = "";
        break;
      case 'onCallQualityWarningsChanged':
        print("this is data onCallQualityWarningsChanged $data");
        var to =
            data['data']['to'] == null ? null : data['data']['to'] as String;
        var from = data['data']['from'] == null
            ? null
            : data['data']['from'] as String;
        var isOnHold = data['data']['isOnHold'] == null
            ? null
            : data['data']['isOnHold'] as bool;
        var isMuted = data['data']['isMuted'] == null
            ? null
            : data['data']['isMuted'] as bool;
        var error = event['error'] != null ? event["error"] : null;
        _outGoingCallCallQualityWarningsChanged
            .add(Call(to, from, isOnHold, isMuted, null, error));
        break;
      default:
        break;
    }
  }

  void _parseIncomingCallEvents(dynamic event) {
    final String eventName = event['name'];
    final data = Map<String, dynamic>.from(event['data']);

    ErrorInfo exception;
    if (event['error'] != null) {
      print("this is error ${event["error"]}");
      final errorMap =
          Map<String, dynamic>.from(event['error'] as Map<dynamic, dynamic>);
      exception = ErrorInfo(errorMap['code'] as int, errorMap['message'], 0);
    }

    switch (eventName) {
      case 'onConnectFailure':
        print("this is data onConnectFailure $data");
        _isOnCall = false;
        var callSid = data['data']['twi_call_sid'] == null
            ? null
            : data['data']['twi_call_sid'] as String;
        var to = data['data']['twi_to'] == null
            ? null
            : data['data']['twi_to'] as String;
        var from = data['data']['twi_from'] == null
            ? null
            : data['data']['twi_from'] as String;
        var customParameters = data['data']['customParameters'] == null
            ? null
            : data['data']['customParameters'] as Map<dynamic, dynamic>;
        var error = event['error'] != null ? event["error"] : null;
        if (customParameters != null) {
          tempChannelInfo = customParameters!['channel_info'] == null
              ? null
              : customParameters['channel_info'] as String;
          tempChannelInfo = tempChannelInfo?.replaceAll("{'", "{\"");
          tempChannelInfo = tempChannelInfo?.replaceAll("':", "\":");
          tempChannelInfo = tempChannelInfo?.replaceAll(": '", ": \"");
          tempChannelInfo = tempChannelInfo?.replaceAll("',", "\",");
          tempChannelInfo = tempChannelInfo?.replaceAll(", '", ", \"");
          tempChannelInfo = tempChannelInfo?.replaceAll("'}", "\"}");
          tempChannelInfo = tempChannelInfo?.replaceAll("None", "null");
        }
        print("this is channel info ${tempChannelInfo}");
        var channelInfo = tempChannelInfo == null
            ? null
            : (json.decode(tempChannelInfo!)) as Map<dynamic, dynamic>;
        _incomingConnectFailure.add(CallInvite(
            callSid, to, from, customParameters, channelInfo, error));
        tempChannelInfo = "";
        break;
      case 'onRinging':
        print("this is data onRinging $data");
        var callSid = data['data']['twi_call_sid'] == null
            ? null
            : data['data']['twi_call_sid'] as String;
        var to = data['data']['twi_to'] == null
            ? null
            : data['data']['twi_to'] as String;
        var from = data['data']['twi_from'] == null
            ? null
            : data['data']['twi_from'] as String;
        var customParameters = data['data']['customParameters'] == null
            ? null
            : data['data']['customParameters'] as Map<dynamic, dynamic>;
        var error = event['error'] != null ? event["error"] : null;

        tempChannelInfo = customParameters!['channel_info'] == null
            ? null
            : customParameters['channel_info'] as String;
        tempChannelInfo = tempChannelInfo?.replaceAll("{'", "{\"");
        tempChannelInfo = tempChannelInfo?.replaceAll("':", "\":");
        tempChannelInfo = tempChannelInfo?.replaceAll(": '", ": \"");
        tempChannelInfo = tempChannelInfo?.replaceAll("',", "\",");
        tempChannelInfo = tempChannelInfo?.replaceAll(", '", ", \"");
        tempChannelInfo = tempChannelInfo?.replaceAll("'}", "\"}");
        tempChannelInfo = tempChannelInfo?.replaceAll("None", "null");
        print("this is channel info ${tempChannelInfo}");
        var channelInfo =
            (json.decode(tempChannelInfo!)) as Map<dynamic, dynamic>;
        _incomingRinging.add(CallInvite(
            callSid, to, from, customParameters, channelInfo, error));
        break;
      case 'onConnected':
        _isOnCall = true;
        print("this is data onConnected $data");
        var callSid = data['data']['twi_call_sid'] == null
            ? null
            : data['data']['twi_call_sid'] as String;
        var to = data['data']['twi_to'] == null
            ? null
            : data['data']['twi_to'] as String;
        var from = data['data']['twi_from'] == null
            ? null
            : data['data']['twi_from'] as String;
        var customParameters = data['data']['customParameters'] == null
            ? null
            : data['data']['customParameters'] as Map<dynamic, dynamic>;
        var error = event['error'] != null ? event["error"] : null;
        tempChannelInfo = customParameters!['channel_info'] as String;
        tempChannelInfo = tempChannelInfo?.replaceAll("{'", "{\"");
        tempChannelInfo = tempChannelInfo?.replaceAll("':", "\":");
        tempChannelInfo = tempChannelInfo?.replaceAll(": '", ": \"");
        tempChannelInfo = tempChannelInfo?.replaceAll("',", "\",");
        tempChannelInfo = tempChannelInfo?.replaceAll(", '", ", \"");
        tempChannelInfo = tempChannelInfo?.replaceAll("'}", "\"}");
        tempChannelInfo = tempChannelInfo?.replaceAll("None", "null");
        print("this is channel info ${tempChannelInfo}");
        var channelInfo =
            (json.decode(tempChannelInfo!)) as Map<dynamic, dynamic>;
        _incomingConnected.add(CallInvite(
            callSid, to, from, customParameters, channelInfo, error));
        break;
      case 'onReconnecting':
        print("this is data onReconnecting $data");
        var callSid = data['data']['twi_call_sid'] == null
            ? null
            : data['data']['twi_call_sid'] as String;
        var to = data['data']['twi_to'] == null
            ? null
            : data['data']['twi_to'] as String;
        var from = data['data']['twi_from'] == null
            ? null
            : data['data']['twi_from'] as String;
        var customParameters = data['data']['customParameters'] == null
            ? null
            : data['data']['customParameters'] as Map<dynamic, dynamic>;
        var error = event['error'] != null ? event["error"] : null;

        tempChannelInfo = customParameters!['channel_info'] == null
            ? null
            : customParameters['channel_info'] as String;
        tempChannelInfo = tempChannelInfo?.replaceAll("{'", "{\"");
        tempChannelInfo = tempChannelInfo?.replaceAll("':", "\":");
        tempChannelInfo = tempChannelInfo?.replaceAll(": '", ": \"");
        tempChannelInfo = tempChannelInfo?.replaceAll("',", "\",");
        tempChannelInfo = tempChannelInfo?.replaceAll(", '", ", \"");
        tempChannelInfo = tempChannelInfo?.replaceAll("'}", "\"}");
        tempChannelInfo = tempChannelInfo?.replaceAll("None", "null");
        print("this is channel info ${tempChannelInfo}");
        var channelInfo =
            (json.decode(tempChannelInfo!)) as Map<dynamic, dynamic>;
        _incomingReconnecting.add(CallInvite(
            callSid, to, from, customParameters, channelInfo, error));
        break;
      case 'onReconnected':
        print("this is data onReconnected $data");
        var callSid = data['data']['twi_call_sid'] == null
            ? null
            : data['data']['twi_call_sid'] as String;
        var to = data['data']['twi_to'] == null
            ? null
            : data['data']['twi_to'] as String;
        var from = data['data']['twi_from'] == null
            ? null
            : data['data']['twi_from'] as String;
        var customParameters = data['data']['customParameters'] == null
            ? null
            : data['data']['customParameters'] as Map<dynamic, dynamic>;
        var error = event['error'] != null ? event["error"] : null;

        tempChannelInfo = customParameters!['channel_info'] == null
            ? null
            : customParameters['channel_info'] as String;
        tempChannelInfo = tempChannelInfo?.replaceAll("{'", "{\"");
        tempChannelInfo = tempChannelInfo?.replaceAll("':", "\":");
        tempChannelInfo = tempChannelInfo?.replaceAll(": '", ": \"");
        tempChannelInfo = tempChannelInfo?.replaceAll("',", "\",");
        tempChannelInfo = tempChannelInfo?.replaceAll(", '", ", \"");
        tempChannelInfo = tempChannelInfo?.replaceAll("'}", "\"}");
        tempChannelInfo = tempChannelInfo?.replaceAll("None", "null");
        print("this is channel info ${tempChannelInfo}");
        var channelInfo =
            (json.decode(tempChannelInfo!)) as Map<dynamic, dynamic>;
        _incomingReconnected.add(CallInvite(
            callSid, to, from, customParameters, channelInfo, error));
        break;
      case 'onDisconnected':
        print("this is data onDisconnected $data");
        _isOnCall = false;
        var callSid = Platform.isIOS
            ? data['data']['callSid'] == null
                ? null
                : data['data']['callSid'] as String
            : data['data']['twi_call_sid'] == null
                ? null
                : data['data']['twi_call_sid'] as String;
        var to = Platform.isIOS
            ? data['data']['to'] == null
                ? null
                : data['data']['to'] as String
            : data['data']['twi_to'] == null
                ? null
                : data['data']['twi_to'] as String;
        var from = Platform.isIOS
            ? data['data']['from'] == null
                ? null
                : data['data']['from'] as String
            : data['data']['twi_from'] == null
                ? null
                : data['data']['twi_from'] as String;
        var error = event['error'] != null ? event["error"] : null;
        // var customParameters =
        //     data['data']['customParameters'] as Map<dynamic, dynamic>;
        //
        // tempChannelInfo = customParameters['channel_info'] as String;
        // tempChannelInfo = tempChannelInfo.replaceAll("{'", "{\"");
        // tempChannelInfo = tempChannelInfo.replaceAll("':", "\":");
        // tempChannelInfo = tempChannelInfo.replaceAll(": '", ": \"");
        // tempChannelInfo = tempChannelInfo.replaceAll("',", "\",");
        // tempChannelInfo = tempChannelInfo.replaceAll(", '", ", \"");
        // tempChannelInfo = tempChannelInfo.replaceAll("'}", "\"}");
        // tempChannelInfo = tempChannelInfo.replaceAll("None", "null");
        // print("this is channel info ${tempChannelInfo}");
        // var channelInfo =
        //     (json.decode(tempChannelInfo)) as Map<dynamic, dynamic>;
        _incomingDisconnected.add(CallInvite(callSid, to, from, {}, {}, error));
        tempChannelInfo = "";
        break;
      case 'onCallQualityWarningsChanged':
        print("this is data onCallQualityWarningsChanged $data");
        var callSid = data['data']['twi_call_sid'] == null
            ? null
            : data['data']['twi_call_sid'] as String;
        var to = data['data']['twi_to'] == null
            ? null
            : data['data']['twi_to'] as String;
        var from = data['data']['twi_from'] == null
            ? null
            : data['data']['twi_from'] as String;
        var customParameters = data['data']['customParameters'] == null
            ? null
            : data['data']['customParameters'] as Map<dynamic, dynamic>;
        var error = event['error'] != null ? event["error"] : null;
        print("this is data onCallQualityWarningsChanged $customParameters");
        if (customParameters != null) {
          tempChannelInfo = customParameters['channel_info'] as String;
          tempChannelInfo = tempChannelInfo?.replaceAll("{'", "{\"");
          tempChannelInfo = tempChannelInfo?.replaceAll("':", "\":");
          tempChannelInfo = tempChannelInfo?.replaceAll(": '", ": \"");
          tempChannelInfo = tempChannelInfo?.replaceAll("',", "\",");
          tempChannelInfo = tempChannelInfo?.replaceAll(", '", ", \"");
          tempChannelInfo = tempChannelInfo?.replaceAll("'}", "\"}");
          tempChannelInfo = tempChannelInfo?.replaceAll("None", "null");
          print("this is channel info ${tempChannelInfo}");
          var channelInfo =
              (json.decode(tempChannelInfo!)) as Map<dynamic, dynamic>;
          _incomingCallQualityWarningsChanged.add(CallInvite(
              callSid!, to!, from!, customParameters, channelInfo, error));
        } else {
          _incomingCallQualityWarningsChanged
              .add(CallInvite("", "", "", {}, {}, error));
        }
        break;
      default:
        break;
    }
  }
}
