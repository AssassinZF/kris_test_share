import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kris_test_share/kris_test_share.dart';

void main() {
  const MethodChannel channel = MethodChannel('kris_test_share');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await KrisTestShare.platformVersion, '42');
  });
}
