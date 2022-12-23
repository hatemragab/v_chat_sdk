import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';

class DirectionItemHolder extends StatelessWidget {
  final Widget child;
  final bool isMeSender;

  const DirectionItemHolder({
    Key? key,
    required this.child,
    required this.isMeSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: context
              .vMessageTheme.vMessageItemBuilder.directionalItemDecoration,
          constraints: context.vMessageTheme.vMessageItemBuilder
              .directionalItemConstraints(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: ["test  $isMeSender".text, Row()],
          ),
        ),
      ],
    );
  }
}
