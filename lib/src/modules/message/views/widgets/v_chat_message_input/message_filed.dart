import 'package:flutter/material.dart';
import '../../../../../services/v_chat_app_service.dart';
import '../../../../../utils/custom_widgets/auto_direction.dart';

class MessageFiled extends StatefulWidget {
  final TextEditingController controller;
  final Function(String txt) onChangeText;
  final Function() onCameraPressed;
  final Function() onAttachmentPressed;

  const MessageFiled(
      {Key? key,
      required this.controller,
      required this.onChangeText,
      required this.onCameraPressed,
      required this.onAttachmentPressed})
      : super(key: key);

  @override
  State<MessageFiled> createState() => _MessageFiledState();
}

class _MessageFiledState extends State<MessageFiled> {
  String txt = "";

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: widget.onCameraPressed,
          child: const Icon(Icons.camera_alt_outlined),
        ),
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 160),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AutoDirection(
                text: txt,
                child: TextField(
                  cursorHeight: 25,
                  controller: widget.controller,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  autofocus: false,
                  maxLines: null,
                  onChanged: (s) {
                    widget.onChangeText(s);
                    setState(() {
                      txt = s.toString();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: VChatAppService.instance
                        .getTrans(context)
                        .yourMessage(),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        InkWell(
            onTap: widget.onAttachmentPressed,
            child: const Icon(Icons.attach_file)),
        const SizedBox(width: 8)
      ],
    );
  }
}
