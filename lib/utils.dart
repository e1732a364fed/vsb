import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

String genUUid() {
  var uuid = const Uuid();
  return uuid.v4();
}

const cardDecoration = BoxDecoration(
  //color: Colors.white,
  //背景装饰
  gradient: RadialGradient(
    //背景径向渐变
    colors: [Colors.white, Colors.amber],
    center: Alignment.topRight,
    radius: .98,
  ),
  boxShadow: [
    //卡片阴影
    BoxShadow(
      color: Colors.black54,
      offset: Offset(2.0, 2.0),
      blurRadius: 4.0,
    )
  ],
);
