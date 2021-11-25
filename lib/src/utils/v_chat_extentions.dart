import 'package:flutter/material.dart';

extension VChatTheme on BuildContext {
  bool get  isDark => Theme.of(this).brightness == Brightness.dark;
}