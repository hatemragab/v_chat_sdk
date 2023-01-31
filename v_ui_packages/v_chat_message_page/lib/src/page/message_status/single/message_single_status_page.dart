import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import 'message_single_status_controller.dart';

class VMessageSingleStatusPage extends StatefulWidget {
  final VBaseMessage message;

  const VMessageSingleStatusPage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<VMessageSingleStatusPage> createState() =>
      _VMessageSingleStatusPageState();
}

class _VMessageSingleStatusPageState extends State<VMessageSingleStatusPage> {
  late final MessageSingleStatusController controller;

  @override
  void initState() {
    controller = MessageSingleStatusController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message info VMessageSingleStatusPage"),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }
}
