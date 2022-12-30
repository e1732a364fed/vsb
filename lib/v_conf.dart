import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsb/model.dart';
import 'package:vsb/vpn.dart';

class ConfView extends StatefulWidget {
  const ConfView({super.key});

  @override
  State<ConfView> createState() => _ConfViewState();
}

class _ConfViewState extends State<ConfView> {
  @override
  void initState() {
    super.initState();
  }

  Widget stateShower(BuildContext context) {
    //debugPrint("stateShower called");
    AppModel model = context.read<AppModel>();
    switch (model.fetchingState) {
      case FetchState.ready:
        return const Text("ready");
      case FetchState.fetching:
        return const CircularProgressIndicator();
      case FetchState.ok:
        return Text(model.allstates);
      case FetchState.error:
        return Text(model.allstatesErr);

      default:
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    AppModel model = context.read<AppModel>();

    return Column(
      children: [
        Consumer<AppModel>(builder: ((context, value, child) {
          return Container();
        })),
        Consumer<AppModel>(builder: ((context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller:
                  TextEditingController(text: model.currentApiServerUrl),
              decoration: const InputDecoration(hintText: 'api server url'),
              onChanged: (value) {
                model.setCurrentApiServerUrl(value);
              },
            ),
          );
        })),
        ElevatedButton(
            onPressed: () {
              model.myfetchAllState();
            },
            child: const Text("连接")),
        Consumer<AppModel>(builder: ((context, value, child) {
          return stateShower(context);
        })),
        Consumer<AppModel>(builder: ((context, value, child) {
          return ElevatedButton(
              onPressed: () {
                model.toggleVpnMode();
              },
              child: Text(model.vpnMode ? "转为面板模式" : "转为vpn模式"));
        })),
        Consumer<AppModel>(builder: ((context, value, child) {
          return const ElevatedButton(
              onPressed: startVpn, child: Text("start"));
        })),
      ],
    );
  }

  int thevalue = 0;
}
