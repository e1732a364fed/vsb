import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grouped_list/grouped_list.dart';

import 'package:vsb/v_add.dart';
import 'package:vsb/v_conf.dart';
import 'package:vsb/v_edit.dart';
import 'package:vsb/utils.dart';
import 'package:vsb/model.dart';
import 'package:vsb/v_vpn.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => AppModel()),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.amber),
        debugShowCheckedModeBanner: false,
        home: const Root(),
        // routes: {
        //   '/': (context) => const Root(),
        //   '/conf': (context) => const ConfView(),
        // },
      ),
    );
  }
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int currentPage = 0;
  AppModel? model;
  @override
  void initState() {
    super.initState();

    model = context.read<AppModel>();
    model!.loadPrefs();
  }

  Widget showDefaultApiPage() {
    AppModel m = model!;

    return Consumer<AppModel>(builder: ((context, value, child) {
      return GroupedListView<dynamic, String>(
        elements: m.proxyDigestList,
        groupBy: (element) {
          return element.isListen ? "监听" : "拨号";
        },
        groupSeparatorBuilder: (String groupByValue) => ListTile(
          title: Container(
            //color: Colors.white,
            padding: const EdgeInsets.all(10.0),
            decoration: cardDecoration,
            child: Text(
              groupByValue,
            ),
          ),
        ),
        itemBuilder: (context, dynamic d) => ListTile(
          tileColor: Colors.white,
          leading: Text(d.fullprotocol,
              style: Theme.of(context).textTheme.bodyText1),
          trailing: Text("#${d.tag}"),
          title: Text(d.addr, style: Theme.of(context).textTheme.bodySmall),
          onTap: () {
            //debugPrint("${d.fullprotocol}");
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => EditView(
                      index: d.index,
                      isListen: d.isListen,
                    ))));
          },
        ),

        useStickyGroupSeparators: true, // optional
        floatingHeader: true, // optional
        order: GroupedListOrder.ASC, // optional
      );
    }));
  }

  Widget showPage(AppModel model) {
    switch (currentPage) {
      case 1:
        return const ConfView();
      default:
        if (model.vpnMode) {
          return const VpnPage();
        } else {
          return showDefaultApiPage();
        }
    }
  }

  Color getFlaBgColor(context, AppModel model) {
    if (model.vpnMode) {
      return (model.vpnRunning) ? Colors.green : Colors.grey;
    }
    return Theme.of(context).backgroundColor;
  }

  Widget? fab(context, AppModel model) {
    if (currentPage == 0) {
      return FloatingActionButton(
        backgroundColor: getFlaBgColor(context, model),
        onPressed: () {
          if (model.vpnMode) {
            model.toggleVpn();
          } else {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return const AddView();
              },
            ));
          }
        },
        child: model.vpnMode
            ? const Icon(Icons.vpn_key_sharp)
            : const Icon(Icons.add),
      );
    }
    return null;
  }

  void tryRestoreDefault() async {
    var userAnswer = showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: const Text("提示"),
              content: const Text("您确定要恢复默认设置吗?"),
              actions: <Widget>[
                TextButton(
                  child: const Text("取消"),
                  onPressed: () => Navigator.of(context).pop(), // 关闭对话框
                ),
                TextButton(
                  child: const Text("嗯, 恢复默认"),
                  onPressed: () {
                    //关闭对话框并返回true
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            )));
    bool? delete = await userAnswer;
    if (delete == true) {
      model!.restoreDefault();
    }
  }

  List<Widget>? actionList() {
    if (currentPage == 1) {
      return [
        IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () {
              tryRestoreDefault();
            })
      ];
    } else if (currentPage == 0) {
      return [
        IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              model!.myfetchAllState();
            })
      ];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    AppModel model = context.read<AppModel>();

    return Scaffold(
      appBar: AppBar(
        title: Consumer<AppModel>(builder: ((context, value, child) {
          return Text(model.vpnMode ? "verysimple" : "vs面板");
        })),
        actions: actionList(),
      ),
      floatingActionButton:
          Consumer<AppModel>(builder: ((context, value, child) {
        var x = fab(context, model);
        return x ?? Container();
      })),
      body: Consumer<AppModel>(builder: ((context, value, child) {
        return showPage(model);
      })),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.rocket), label: '代理'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '配置'),
        ],
        currentIndex: currentPage,
        onTap: (int value) {
          setState(() {
            currentPage = value;
          });
        },
      ),
    );
  }
}
