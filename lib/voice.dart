
import 'dart:async';

import 'package:flutter/services.dart';

class Voice {
  static const MethodChannel _channel = const MethodChannel('voice');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
