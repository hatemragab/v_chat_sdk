import 'package:flutter/material.dart';
import 'package:v_chat_message_page/src/models/app_bare_state_model.dart';

import '../message_items/shared/message_typing_widget.dart';

class VMessageAppBare extends StatelessWidget {
  final MessageAppBarStateModel state;

  const VMessageAppBare({
    Key? key,
    required this.state,
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
    );
  }
}
