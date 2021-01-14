part of flutter_twilio_voice;

/// Entry point for the Twilio Programmable Dart.
class TwilioVoice {
  static const MethodChannel _methodChannel = MethodChannel('TwilioVoice');

  static const EventChannel _chatChannel = EventChannel('TwilioVoice/room');

  static const EventChannel _loggingChannel = EventChannel('TwilioVoice/logging');

  static const EventChannel _notificationChannel = EventChannel('TwilioVoice/notification');

  static StreamSubscription _loggingStream;

  static bool _dartDebug = false;

  static VoiceClient voiceClient;

  static Exception _convertException(PlatformException err) {
    var code = int.tryParse(err.code);
    // If code is an integer, then it is a Twilio ErrorInfo exception.
    if (code != null) {
      return ErrorInfo(int.parse(err.code), err.message, err.details as int);
    }

    // For now just rethrow the PlatformException. But we could make custom ones based on the code value.
    // code can be:
    // - "ERROR" Something went wrong in the custom native code.
    // - "IllegalArgumentException" Something went wrong calling the twilio SDK.
    // - "JSONException" Something went wrong parsing a JSON string.
    // - "MISSING_PARAMS" Missing params, only the native debug method uses this at the moment.
    return err;
  }

  /// Internal logging method for dart.
  static void _log(dynamic msg) {
    if (_dartDebug) {
      print('[   DART   ] $msg');
    }
  }

  /// Enable debug logging.
  ///
  /// For native logging set [native] to `true` and for dart set [dart] to `true`.
  static Future<void> debug({
    bool dart = false,
    bool native = false,
    bool sdk = false,
  }) async {
    assert(dart != null);
    assert(native != null);
    assert(sdk != null);
    _dartDebug = dart;
    await _methodChannel.invokeMethod('debug', {'native': native, 'sdk': sdk});
    if (native && _loggingStream == null) {
      _loggingStream = _loggingChannel.receiveBroadcastStream().listen((dynamic event) {
        if (native) {
          print('[  NATIVE  ] $event');
        }
      });
    } else if (!native && _loggingStream != null) {
      await _loggingStream.cancel();
      _loggingStream = null;
    }
  }

  /// Create to a [ChatClient].
  static Future<VoiceClient> create(String accessToken) async {
    assert(accessToken != null);
    assert(accessToken != '');

    if (voiceClient != null) {
      throw UnsupportedError('Instantiation of multiple chatClients is not supported.'
          ' Shutdown the existing chatClient before creating a new one');
    }

    try {
      final methodData = await _methodChannel.invokeMethod('create', <String, Object>{'accessToken': accessToken,});
      final chatClientMap = Map<String, dynamic>.from(methodData);
      voiceClient = VoiceClient._fromMap(chatClientMap);
      return voiceClient;
    } on PlatformException catch (err) {
      throw TwilioVoice._convertException(err);
    }
  }
}
