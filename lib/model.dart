import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vsb/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProxyDigest {
  int index = 0;
  String tag = "";
  String fullprotocol = "";
  String protocol = "";
  String addr = "";
  bool isListen = false;

  ProxyDigest(String t, String p, String a) {
    tag = t;
    fullprotocol = p;
    addr = a;
    protocol = p.split("+").last;
  }
}

enum FetchState {
  ready,
  fetching,
  ok,
  error,
}

class AppModel with ChangeNotifier {
  String currentApiServerUrl = defaultApiUrl;

  bool vpnMode = false;
  String curDialConfStr = "";
  String curScanedStr = "";

  List<ProxyDigest> proxyDigestList = [];

  String allstates = "";
  String allstatesErr = "";
  String addingUrl = "";
  String addingResult = "";
  String deleteResult = "";

  bool addingUrlIsListen = false;
  int curRequestScanSource = 0; //1 curDialConfStr;

  FetchState fetchingState = FetchState.ready;
  FetchState addingState = FetchState.ready;
  FetchState deleteState = FetchState.ready;

  static const String keyCurrentApiServerUrl = "currentApiServerUrl";
  static const String keyIsVpnMode = "IsVpnMode";
  static const String keyCurDialConfStr = "curDialConfStr";

  void toggleVpnMode() async {
    vpnMode = !vpnMode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(keyIsVpnMode, vpnMode);
  }

  void restoreDefault() {
    setCurrentApiServerUrl(defaultApiUrl);
    setDialConfStr("");
  }

  void setCurScannedStr(String s) {
    curScanedStr = s;

    switch (curRequestScanSource) {
      case 1:
        setDialConfStr(s);
        break;
      default:
        notifyListeners();
    }
    curRequestScanSource = 0;
  }

  void setCurrentApiServerUrl(String s) async {
    currentApiServerUrl = s;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(keyCurrentApiServerUrl, s);
  }

  //set and save to pref
  void setDialConfStr(String s) async {
    curDialConfStr = s;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(keyCurDialConfStr, s);
  }

  void loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    currentApiServerUrl =
        prefs.getString(keyCurrentApiServerUrl) ?? defaultApiUrl;

    curDialConfStr = prefs.getString(keyCurDialConfStr) ?? "";

    vpnMode = prefs.getBool(keyIsVpnMode) ?? false;

    notifyListeners();
  }

  void myfetchAllState() async {
    allstatesErr = "";
    fetchingState = FetchState.fetching;
    notifyListeners();
    try {
      allstates = await getAllState();
      fetchingState = FetchState.ok;
      loadToDigest();
    } catch (e) {
      allstatesErr = e.toString();
      fetchingState = FetchState.error;
      notifyListeners();
    }
  }

  Future<String> getAllState() {
    return fetchAllState(currentApiServerUrl);
  }

  void loadToDigest() {
    List<String> lines = const LineSplitter().convert(allstates);

    List<ProxyDigest> tmpList = [];

    for (var l in lines) {
      var isServer = l.startsWith('inServer');
      var isClient = l.startsWith('outClient');

      if (isServer || isClient) {
        var strs = l.split(' ');
        var str = strs[2];
        var idx = int.parse(strs[1]);
        strs = str.split("://");
        var fullprotocol = strs[0];
        strs = strs[1].split("#");
        var tag = strs.length > 1 ? strs[1] : "";
        if (fullprotocol.indexOf("+") == 0) {
          fullprotocol = fullprotocol.substring(1);
        }

        ProxyDigest pd = ProxyDigest(tag, fullprotocol, strs[0]);
        pd.index = idx;
        if (isServer) {
          pd.isListen = true;
          tmpList.add(pd);
        } else {
          tmpList.add(pd);
        }

        //debugPrint("${pd.tag} ${pd.fullprotocol} ${pd.addr} ${pd.protocol}");
      }
    }

    proxyDigestList = tmpList;

    notifyListeners();
  }

  void myTryAdd() async {
    addingResult = "";
    addingState = FetchState.fetching;
    notifyListeners();
    try {
      var o = <String, dynamic>{};
      o[addingUrlIsListen ? 'listen' : 'dial'] = addingUrl;

      ApiResult ar = await runPost("$currentApiServerUrl/hotLoadUrl", o);
      addingResult = ar.result;

      if (ar.ok) {
        addingState = FetchState.ok;
      } else {
        addingState = FetchState.error;
      }

      notifyListeners();
    } catch (e) {
      addingResult = e.toString();
      addingState = FetchState.error;
      notifyListeners();
    }
  }

  void myTryDelete(int index, bool isListen) async {
    deleteState = FetchState.fetching;
    notifyListeners();
    try {
      var getStr = "$currentApiServerUrl/hotDelete?";
      if (isListen) {
        getStr += "&listen=$index";
      } else {
        getStr += "&dial=$index";
      }

      deleteResult = await runGet(getStr);

      deleteState = FetchState.ok;

      notifyListeners();
    } catch (e) {
      deleteResult = e.toString();
      deleteState = FetchState.error;
      notifyListeners();
    }
  }
}
