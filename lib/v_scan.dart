import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vsb/model.dart';
import 'package:provider/provider.dart';

class Scan1 extends StatefulWidget {
  const Scan1({super.key});

  @override
  State<Scan1> createState() => _Scan1State();
}

class _Scan1State extends State<Scan1> {
  MobileScannerController cameraController = MobileScannerController();
  AppModel? model;

  @override
  void initState() {
    super.initState();

    model = context.read<AppModel>();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      allowDuplicates: false,
      controller: cameraController,
      onDetect: _foundBarcode,
    );
  }

  void _foundBarcode(Barcode bc, MobileScannerArguments? args) {
    final String code = bc.rawValue ?? "...";
    //debugPrint(code);
    model!.setCurScannedStr(code);
    Navigator.pop(context);
  }
}
