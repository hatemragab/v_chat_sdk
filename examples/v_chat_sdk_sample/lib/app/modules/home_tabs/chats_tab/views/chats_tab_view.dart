import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chats_tab_controller.dart';

class ChatsTabView extends GetView<ChatsTabController> {
  const ChatsTabView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatsTabView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ChatsTabView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
