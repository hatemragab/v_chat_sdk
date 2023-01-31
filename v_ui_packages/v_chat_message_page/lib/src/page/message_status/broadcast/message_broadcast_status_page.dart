import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import 'message_broadcast_status_controller.dart';

class VMessageBroadcastStatusPage extends StatefulWidget {
  final VBaseMessage message;


  const VMessageBroadcastStatusPage({
    Key? key,
    required this.message,

  }) : super(key: key);

  @override
  State<VMessageBroadcastStatusPage> createState() => _VMessageBroadcastStatusPageState();
}

class _VMessageBroadcastStatusPageState extends State<VMessageBroadcastStatusPage> {
  late final MessageBroadcastStatusController controller;

  @override
  void initState() {
    controller = MessageBroadcastStatusController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message info VMessageBroadcastStatusPage"),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }
}
