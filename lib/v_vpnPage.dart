import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsb/model.dart';
import 'package:vsb/vpn.dart';
import 'package:vsb/v_scan.dart';

class VpnPage extends StatefulWidget {
  const VpnPage({super.key});

  @override
  State<VpnPage> createState() => _VpnPageState();
}

class _VpnPageState extends State<VpnPage> {
  final urlTextCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppModel model = context.read<AppModel>();

    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: (() {
                model.curRequestScanSource = 1;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Scan1()));
              }),
              child: const Text("扫描toml二维码")),
          Consumer<AppModel>(builder: ((context, value, child) {
            urlTextCtrl.text = model.curDialConfStr;

            return TextField(
              controller: urlTextCtrl,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 4,
            );
          })),
          ElevatedButton(
              onPressed: (() {
                model.setDialConfStr(urlTextCtrl.text);
              }),
              child: const Text("save")),
          Consumer<AppModel>(builder: ((context, value, child) {
            return ElevatedButton(
                onPressed: (() {
                  passDialConfStrToVpn(model.curDialConfStr);
                }),
                child: const Text("passDialConfStr"));
          })),
        ],
      ),
    );
  }
}
