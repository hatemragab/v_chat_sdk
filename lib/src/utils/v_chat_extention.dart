import 'package:flutter/material.dart';

extension VChatIsDark on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
