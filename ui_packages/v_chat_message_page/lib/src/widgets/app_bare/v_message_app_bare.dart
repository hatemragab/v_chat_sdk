import 'package:flutter/material.dart';
import 'package:v_chat_message_page/src/models/app_bare_state_model.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../message_items/shared/message_typing_widget.dart';

class VMessageAppBare extends StatelessWidget {
  final MessageAppBarStateModel state;
  final Function(BuildContext context, String id, VRoomType roomType)
      onTitlePress;

  const VMessageAppBare({
    Key? key,
    required this.state,
    required this.onTitlePress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: ListTile(
        onTap: () {
          onTitlePress(
            context,
            state.peerIdentifier ?? state.roomId,
            state.roomType,
          );
        },
        title: Text(
          state.roomTitle,
        ),
        subtitle: state.typingText != null
            ? MessageTypingWidget(
                text: state.typingText!,
              )
            : null,
      ),
    );
  }
}
