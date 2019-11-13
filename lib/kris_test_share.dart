import 'dart:async';

import 'package:flutter/services.dart';

class KrisTestShare {
  static const MethodChannel _channel =
      const MethodChannel('kris_test_share');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
