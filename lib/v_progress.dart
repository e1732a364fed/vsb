import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsb/model.dart';

class AddProcessDialog extends StatelessWidget {
  const AddProcessDialog({super.key});

  Widget title(BuildContext context) {
    AppModel m = context.read<AppModel>();
    switch (m.addingState) {
      case FetchState.ready:
        return const Text("准备添加");
      case FetchState.fetching:
        return const Text("添加中");
      case FetchState.ok:
        return const Text("添加成功");
      case FetchState.error:
        return const Text("添加失败");

      default:
    }
    return Container();
  }

  Widget stateShower(BuildContext context) {
    AppModel m = context.read<AppModel>();
    switch (m.addingState) {
      case FetchState.ready:
        return const Text("ready");
      case FetchState.fetching:
        return const CircularProgressIndicator();
      case FetchState.ok:

      case FetchState.error:
        return Text(m.addingResult);

      default:
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Consumer<AppModel>(builder: ((context, value, child) {
        return title(context);
      })),
      children: [
        Column(
          children: [
            Consumer<AppModel>(builder: ((context, value, child) {
              return stateShower(context);
            })),
          ],
        ),
      ],
    );
  }
}

class DeleteProcessDialog extends StatelessWidget {
  const DeleteProcessDialog({super.key});

  Widget stateShower(BuildContext context) {
    AppModel m = context.read<AppModel>();
    switch (m.deleteState) {
      case FetchState.ready:
        return const Text("ready");
      case FetchState.fetching:
        return const CircularProgressIndicator();
      case FetchState.ok:
        return Text("result: ${m.deleteResult}");
      case FetchState.error:
        return Text("err: ${m.deleteResult}");

      default:
    }
    return Container();
  }

  Widget title(BuildContext context) {
    AppModel m = context.read<AppModel>();
    switch (m.deleteState) {
      case FetchState.ready:
        return const Text("准备删除");
      case FetchState.fetching:
        return const Text("删除中");
      case FetchState.ok:
        return const Text("删除成功");
      case FetchState.error:
        return const Text("删除失败");

      default:
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Consumer<AppModel>(builder: ((context, value, child) {
        return title(context);
      })),
      children: [
        Column(
          children: [
            Consumer<AppModel>(builder: ((context, value, child) {
              return stateShower(context);
            })),
          ],
        ),
      ],
    );
  }
}
