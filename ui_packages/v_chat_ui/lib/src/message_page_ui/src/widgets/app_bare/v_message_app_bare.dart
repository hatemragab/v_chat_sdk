import 'package:flutter/material.dart';
import 'package:v_chat_ui/src/message_page_ui/src/models/app_bare_state.dart';

class VMessageAppBare extends StatelessWidget {
  final AppBareState state;

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
        subtitle: state.typingText != null ? Text(state.typingText!) : null,
      ),
    );
  }
}
