import 'package:flutter/material.dart';

import '../../models/app_bare_state.dart';
import '../shared/message_typing_widget.dart';

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
        subtitle: state.typingText != null
            ? MessageTypingWidget(
                text: state.typingText!,
              )
            : null,
      ),
    );
  }
}
