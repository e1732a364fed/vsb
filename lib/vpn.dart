import 'package:flutter/services.dart';

const platform = MethodChannel('samples.flutter.dev/battery');

Future<void> startVpn() async {
  await platform.invokeMethod('start');

  return;
}

Future<void> passDialConfStrToVpn(String x) async {
  await platform.invokeMethod('setDialConfStr', {"text": x});

  return;
}
