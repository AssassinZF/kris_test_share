import 'dart:async';

import 'package:flutter/services.dart';

class KrisTestShare {
  static const MethodChannel _channel = const MethodChannel('kris_test_share');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  //share to facebook
  static Future<String> shareFacebook(
      {String msg = '', String url = ''}) async {
    final Map<String, Object> arguments = Map<String, dynamic>();
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => url);
    dynamic result;
    try {
      result = await _channel.invokeMethod('shareFacebook', arguments);
    } catch (e) {
      return "false";
    }
    return result;
  }
}
