import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const defaultApiUrl = "https://127.0.0.1:48345/api";

class ApiResult {
  bool ok = true;
  ApiFailReason failReason = ApiFailReason.none;
  String result = "";
  int statusCode = 0;
}

enum ApiFailReason { none, network, inner }

Future<String> fetchAllState(String url) async {
  String str = '$url/allstate';
  debugPrint("fetching $str");

  return runGet(str);
}

Future<String> runGet(String url) async {
  debugPrint("runGet $url");

//模拟网络缓慢的情况
  //await Future.delayed(const Duration(seconds: 2), () {});
  try {
    var x = await http.get(Uri.parse(url));

    debugPrint("run ok ${x.body}");
    return x.body;
  } catch (e) {
    debugPrint("run notok");
    debugPrint(e.toString());

    return Future.error(e);
  }
}

Future<ApiResult> runPost(String url, Object o) async {
  debugPrint("runPost $url $o");
  //await Future.delayed(const Duration(seconds: 2), () {});

  try {
    var x = await http.post(Uri.parse(url), body: o);

    //debugPrint("run ok ${x.body}");
    ApiResult r = ApiResult();
    r.result = x.body;
    r.statusCode = x.statusCode;
    if (x.statusCode != 200) {
      r.failReason = ApiFailReason.inner;

      r.ok = false;
    }
    return r;
  } catch (e) {
    //debugPrint("run notok");
    //debugPrint(e.toString());

    ApiResult r = ApiResult();
    r.ok = false;
    r.failReason = ApiFailReason.network;
    r.result = e.toString();
    return r;
    //return Future.error(e);
  }
}
