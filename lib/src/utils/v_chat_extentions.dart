import 'package:flutter/material.dart';
import 'package:v_chat_sdk/src/services/v_chat_app_service.dart';

extension VChatTheme on BuildContext {
  bool get  isDark => Theme.of(this).brightness == Brightness.dark;
}