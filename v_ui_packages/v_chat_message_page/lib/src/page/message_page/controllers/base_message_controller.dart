import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

abstract class BaseMessageController {
  final focusNode = FocusNode();

  void onTitlePress(
    BuildContext context,
    String id,
    VRoomType roomType,
  );
}
