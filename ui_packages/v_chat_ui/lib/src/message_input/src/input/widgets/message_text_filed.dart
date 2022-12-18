import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:v_chat_mention_controller/v_chat_mention_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MessageTextFiled extends StatelessWidget {
  final VChatTextMentionController textEditingController;
  final FocusNode focusNode;
  final bool isTyping;
  final VoidCallback onShowEmoji;
  final VoidCallback onCameraPress;
  final VoidCallback onAttachFilePress;
  final Function(String value) onSubmit;

  const MessageTextFiled({
    super.key,
    required this.textEditingController,
    required this.focusNode,
    required this.onShowEmoji,
    required this.onCameraPress,
    required this.onAttachFilePress,
    required this.isTyping,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: onShowEmoji,
          child: const Icon(
            PhosphorIcons.smiley,
            size: 26,
            color: Colors.green,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0, top: 0),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: textEditingController,
              focusNode: focusNode,
              maxLines: 5,
              style: const TextStyle(height: 1.3),
              minLines: 1,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 7, bottom: 5),
                border: InputBorder.none,
                hintText: "Type your message",
                fillColor: Colors.transparent,
                isDense: true,
                //constraints: BoxConstraints(maxHeight: 30, minHeight: 20),
              ),
              onSubmitted: Platforms.isMobile
                  ? null
                  : (value) {
                      if (value.isNotEmpty) {
                        onSubmit(value);
                      }
                      focusNode.requestFocus();
                      textEditingController.clear();
                    },
              textInputAction:
                  !Platforms.isMobile ? null : TextInputAction.newline,
              keyboardType: Platforms.isMobile
                  ? TextInputType.multiline
                  : TextInputType.text,
            ),
          ),
        ),
        const SizedBox(
          width: 3,
        ),
        Visibility(
          visible: !isTyping,
          child: Row(
            children: [
              if (Platforms.isMobile)
                InkWell(
                  onTap: onCameraPress,
                  child: const Icon(
                    PhosphorIcons.camera,
                    size: 26,
                    color: Colors.green,
                  ),
                ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onAttachFilePress,
          child: const Icon(
            PhosphorIcons.paperclip,
            size: 26,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
