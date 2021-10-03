import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:v_chat_sdk/src/services/vchat_app_service.dart';

class VChatWrapper extends StatefulWidget {
  final Widget child;
  final Map<String, String> trans;
  final ThemeData light;
  final ThemeData dark;

  const VChatWrapper(
      {required this.child,
      required this.trans,
      Key? key,
      required this.light,
      required this.dark})
      : super(key: key);

  @override
  _VChatWrapperState createState() => _VChatWrapperState();
}

class _VChatWrapperState extends State<VChatWrapper> {
  @override
  Widget build(BuildContext context) {
    KeyboardVisibilityController().onChange.listen((visible) {
      if (!visible) {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      }
    });
    final controller = VChatAppService.to;
    controller.context = context;
    controller.light = widget.light;
    controller.dark = widget.dark;
    controller.trans = widget.trans;
    return KeyboardDismissOnTap(
      child: widget.child,
    );
  }
}
