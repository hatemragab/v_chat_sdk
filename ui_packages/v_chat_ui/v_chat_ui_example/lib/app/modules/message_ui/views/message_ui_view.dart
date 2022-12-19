import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/message_ui_controller.dart';

class MessageUiView extends GetView<MessageUiController> {
  const MessageUiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MessageUiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MessageUiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
