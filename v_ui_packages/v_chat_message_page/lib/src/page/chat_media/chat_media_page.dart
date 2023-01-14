import 'package:flutter/material.dart';

import 'chat_media_controller.dart';

class ChatMediaPage extends StatefulWidget {
  final String roomId;

  const ChatMediaPage({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  @override
  State<ChatMediaPage> createState() => _ChatMediaPageState();
}

class _ChatMediaPageState extends State<ChatMediaPage> {
  late final VChatMediaController controller;

  @override
  void initState() {
    controller = VChatMediaController(widget.roomId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("chat media"),
      ),
    );
  }
}
