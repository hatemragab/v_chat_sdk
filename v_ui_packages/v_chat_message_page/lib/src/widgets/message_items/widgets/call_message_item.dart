import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class CallMessageItem extends StatelessWidget {
  final VCallMessage message;

  const CallMessageItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            PhosphorIcons.phoneCall,
            size: 35,
          ),
          Expanded(
            child: ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              dense: true,
              //todo fix
              title: "Audio call".text,
              subtitle: message.data.callStatus.name
                  .toString()
                  .text
                  .maxLine(2)
                  .overflowEllipsis,
            ),
          )
        ],
      ),
    );
  }
}
