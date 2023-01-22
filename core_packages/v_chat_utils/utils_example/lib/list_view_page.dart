import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ListViewPageState();
  }
}

class ListViewPageState extends State<ListViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          VImagePicker(
            onDone: (file) {},
            size: 100,
            initImage:
                VPlatformFileSource.fromAssets(assetsPath: "assets/logo.png"),
          ),
          TextButton(
            onPressed: () async {
              VAppAlert.showLoading(context: context);
              await Future.delayed(const Duration(seconds: 5));
              Navigator.pop(context);
            },
            child: const Text("show loading alert"),
          )
        ],
      ),
    );
  }
}
