import 'package:flutter/material.dart';
import 'package:v_chat_message_page/src/models/app_bare_state_model.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../message_items/shared/message_typing_widget.dart';

class VTestingMessageAppBare extends StatelessWidget {
  final MessageAppBarStateModel state;
  final Function(VSocketRoomTypingModel) onTyping;
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
        subtitle: state.typingText != null
            ? MessageTypingWidget(
                text: state.typingText!,
              )
            : null,
      ),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: const Text("send typing"),
                onTap: () {
                  onTyping(VSocketRoomTypingModel.typing);
                },
              ),
            ];
          },
        )
      ],
    );
  }
}
