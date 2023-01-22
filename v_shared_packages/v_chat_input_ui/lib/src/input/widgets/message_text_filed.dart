import 'package:flutter/material.dart';
import 'package:v_chat_input_ui/src/models/v_input_theme.dart';
import 'package:v_chat_mention_controller/v_chat_mention_controller.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class MessageTextFiled extends StatefulWidget {
  final VChatTextMentionController textEditingController;
  final FocusNode focusNode;
  final bool isTyping;
  final bool autofocus;
  final String hint;
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
    required this.autofocus,
    required this.hint,
    required this.onSubmit,
  });

  @override
  State<MessageTextFiled> createState() => _MessageTextFiledState();
}

class _MessageTextFiledState extends State<MessageTextFiled> {
  String txt = "";
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: widget.onShowEmoji,
          child: context.vInputTheme.emojiIcon,
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0, top: 0),
            child: AutoDirection(
              text: txt,
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: widget.textEditingController,
                focusNode: widget.focusNode,
                autofocus: widget.autofocus,
                maxLines: 5,
                onChanged: (value) {
                  setState(() {
                    txt = value;
                  });
                },
                style: context.vInputTheme.textFieldTextStyle,
                minLines: 1,
                decoration: context.vInputTheme.textFieldDecoration
                    .copyWith(hintText: widget.hint),
                onSubmitted: VPlatforms.isMobile
                    ? null
                    : (value) {
                        if (value.isNotEmpty) {
                          widget.onSubmit(value);
                        }
                        widget.focusNode.requestFocus();
                        widget.textEditingController.clear();
                      },
                textInputAction:
                    !VPlatforms.isMobile ? null : TextInputAction.newline,
                keyboardType: VPlatforms.isMobile
                    ? TextInputType.multiline
                    : TextInputType.text,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 3,
        ),
        Visibility(
          visible: !widget.isTyping,
          child: Row(
            children: [
              if (VPlatforms.isMobile)
                InkWell(
                  onTap: widget.onCameraPress,
                  child: context.vInputTheme.cameraIcon,
                ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        InkWell(
          onTap: widget.onAttachFilePress,
          child: context.vInputTheme.fileIcon,
        ),
      ],
    );
  }
}
