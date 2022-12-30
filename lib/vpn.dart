import 'dart:convert';

import 'package:flutter/services.dart';

const platform = MethodChannel('samples.flutter.dev/battery');

Future<void> startVpn() async {
  await platform.invokeMethod('start');

  return;
}

Future<void> passDialConfStrToVpn(String dialConf) async {
  await platform
      .invokeMethod('setDialConfStr', {"text": filterDialConfStr(dialConf)});

  return;
}

Future<void> passDialConfStrToVpnAndStart(String dialConf) async {
  await passDialConfStrToVpn(dialConf);
  await startVpn();

  return;
}

String filterDialConfStr(String dialConf) {
  LineSplitter ls = const LineSplitter();
  List<String> lines = ls.convert(dialConf);
  String r = "";
  for (var l in lines) {
    if (!l.contains("sockopt")) {
      //过滤掉bindToDevice，因为用不到
      r += l;
      r += "\n";
    }
  }
  return r;
}
