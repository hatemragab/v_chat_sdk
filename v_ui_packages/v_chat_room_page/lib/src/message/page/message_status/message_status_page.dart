import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/message/page/message_status/message_status_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VMessageStatusPage extends StatefulWidget {
  final VBaseMessage message;
  final VRoom room;

  const VMessageStatusPage({
    Key? key,
    required this.message,
    required this.room,
  }) : super(key: key);

  @override
  State<VMessageStatusPage> createState() => _VMessageStatusPageState();
}

class _VMessageStatusPageState extends State<VMessageStatusPage> {
  late final MessageStatusController controller;

  @override
  void initState() {
    controller = MessageStatusController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message info"),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }
}
