import 'package:vsb/v_progress.dart';
import 'package:provider/provider.dart';
import 'package:vsb/model.dart';
import 'package:vsb/utils.dart';

import 'package:flutter/material.dart';

class UrlView extends StatefulWidget {
  const UrlView({super.key});

  @override
  State<UrlView> createState() => _UrlViewState();
}

class _UrlViewState extends State<UrlView> {
  final urlTextCtrl = TextEditingController();
  bool confirmEnabled = false;
  String urlStr = "";
  bool _islisten = true;

  @override
  void initState() {
    super.initState();

    urlTextCtrl.addListener(() {
      var value = urlTextCtrl.text;
      urlStr = value;

      if (value == "" && confirmEnabled) {
        setState(() {
          confirmEnabled = false;
        });
      } else if (!confirmEnabled) {
        setState(() {
          confirmEnabled = true;
        });
      }
    });
  }

  Widget urlConfirmButton() {
    if (!confirmEnabled) {
      return Container();
    }
    return ElevatedButton(
      onPressed: () {
        AppModel model = context.read<AppModel>();
        model.addingUrlIsListen = _islisten;
        model.addingUrl = urlStr;

        model.myTryAdd();
        showDialog(context: context, builder: (c) => const AddProcessDialog())
            .then((value) {
          if (model.addingState == FetchState.ok) {
            Navigator.pop(context);
            model.myfetchAllState();
          }
        });
      },
      child: const Text("确定"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text("扫码")),
            ElevatedButton(
                onPressed: () {
                  urlTextCtrl.text = "vlesss://${genUUid()}@0.0.0.0:4433#vless";
                },
                child: const Text("快速插入")),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.link),
            Text(_islisten ? "listen url" : "dial url"),
            const Spacer(),
            Switch(
              value: _islisten, //当前状态
              onChanged: (value) {
                //重新构建页面
                setState(() {
                  _islisten = value;
                });
              },
            ),
          ],
        ),
        TextField(
          controller: urlTextCtrl,
          decoration: const InputDecoration(
              labelText: "vs标准url",
              hintText: "vlesss://uuid@0.0.0.0:443",
              prefixIcon: Icon(Icons.lock)),
        ),
        urlConfirmButton(),
      ],
    );
  }
}
