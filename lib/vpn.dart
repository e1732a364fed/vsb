import 'dart:convert';

import 'package:flutter/services.dart';

const methodChannel1 = MethodChannel('vsb.e1732a364fed.github/channel1');

Future<bool> startVpn() async {
  await methodChannel1.invokeMethod('start');

  return true;
}

Future<void> stopVpn() async {
  await methodChannel1.invokeMethod('stop');

  return;
}

Future<void> passDialConfStrToVpn(String dialConf) async {
  await methodChannel1
      .invokeMethod('setDialConfStr', {"text": filterDialConfStr(dialConf)});

  return;
}

//helper func, call both
Future<bool> passDialConfStrToVpnAndStart(String dialConf) async {
  await passDialConfStrToVpn(dialConf);
  var r = await startVpn();

  return r;
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
