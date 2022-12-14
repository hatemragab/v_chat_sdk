import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../models/app_bare_state.dart';

class VTestingMessageAppBare extends StatelessWidget {
  final AppBareState state;
  final Function(RoomTypingModel) onTyping;
  const VTestingMessageAppBare({
    Key? key,
    required this.state,
    required this.onTyping,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: ListTile(
        title: Text(
          state.roomTitle,
        ),
        subtitle: state.typingText != null ? Text(state.typingText!) : null,
      ),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: const Text("send typing"),
                onTap: () {
                  onTyping(RoomTypingModel.typing);
                },
              ),
            ];
          },
        )
      ],
    );
  }
}
