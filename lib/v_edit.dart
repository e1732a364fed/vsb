import 'package:flutter/material.dart';
import 'package:vsb/v_progress.dart';
import 'package:provider/provider.dart';
import 'package:vsb/model.dart';

class EditView extends StatefulWidget {
  //const EditView({super.key});
  final int index;
  final bool isListen;

  @override
  State<EditView> createState() => _EditViewState();

  const EditView({Key? key, this.index = 0, this.isListen = false})
      : super(key: key);
}

class _EditViewState extends State<EditView> {
  int index = 0;
  bool isListen = false;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    isListen = widget.isListen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("编辑配置"),
          actions: <Widget>[
            IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.link),
                Text(isListen ? "listen url" : "dial url"),
                const Spacer(),
                Text("$index"),
              ],
            ),
            MaterialButton(
              minWidth: double.infinity,
              onPressed: () {
                AppModel m = context.read<AppModel>();
                m.myTryDelete(index, isListen);
                showDialog(
                    context: context,
                    builder: (c) => const DeleteProcessDialog()).then((value) {
                  Navigator.pop(context);
                  m.myfetchAllState();
                });
              },
              color: Colors.red,
              textColor: Colors.white,
              child: const Text("删除该配置"),
            ),
          ],
        ));
  }
}
