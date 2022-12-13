import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MessageTextFiled extends StatelessWidget {
  final AnnotationEditingController textEditingController;
  final FocusNode focusNode;
  final bool isTyping;
  final VoidCallback onShowEmoji;
  final VoidCallback onCameraPress;
  final Widget Function(Map<String, dynamic>)? suggestionBuilder;

  final VoidCallback onAttachFilePress;
  final Function(String value) onSubmit;
  final List<Map<String, dynamic>> searchData;
  final void Function(String trigger, String value)? onSearchChanged;

  const MessageTextFiled({
    super.key,
    required this.textEditingController,
    required this.onSearchChanged,
    required this.focusNode,
    required this.onShowEmoji,
    required this.suggestionBuilder,
    required this.onCameraPress,
    required this.onAttachFilePress,
    required this.isTyping,
    required this.onSubmit,
    required this.searchData,
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
            size: 28,
            color: Colors.green,
          ),
        ),
        const SizedBox(
          width: 10,
        ),

        ///mention!

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5, top: 5),
            child: FlutterMentions(
              onSearchChanged: onSearchChanged,
              annotationEditingController: textEditingController,
              suggestionPosition: SuggestionPosition.Top,
              textCapitalization: TextCapitalization.sentences,
              focusNode: focusNode,
              maxLines: 5,
              minLines: 1,
              suggestionListHeight: 400,
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
              decoration: InputDecoration.collapsed(
                ///todo trans
                hintText: "typeAMessage",
              ),
              keyboardType: Platforms.isMobile
                  ? TextInputType.multiline
                  : TextInputType.text,
              mentions: [
                Mention(
                  suggestionBuilder: suggestionBuilder,
                  style: const TextStyle(color: Colors.blue),
                  trigger: '@',
                  data: searchData,
                )
              ],
            ),
          ),
        ),

        const SizedBox(
          width: 10,
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
                    size: 25,
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
            size: 25,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
