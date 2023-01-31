import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import 'message_group_status_controller.dart';

class VMessageGroupStatusPage extends StatefulWidget {
  final VBaseMessage message;


  const VMessageGroupStatusPage({
    Key? key,
    required this.message,

  }) : super(key: key);

  @override
  State<VMessageGroupStatusPage> createState() => _VMessageGroupStatusPageState();
}

class _VMessageGroupStatusPageState extends State<VMessageGroupStatusPage> {
  late final MessageGroupStatusController controller;

  @override
  void initState() {
    controller = MessageGroupStatusController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Message info Group"),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }
}
