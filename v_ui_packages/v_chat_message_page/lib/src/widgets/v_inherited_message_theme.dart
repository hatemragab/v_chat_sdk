import 'package:flutter/widgets.dart';

import '../theme/v_message_theme_new.dart';

/// Used to make provided [MessageTheme] class available through the whole package.
class VInheritedMessageTheme extends InheritedWidget {
  /// Creates [InheritedWidget] from a provided [VMessageTheme] class.
  const VInheritedMessageTheme({
    super.key,
    required this.theme,
    required super.child,
  });

  /// Represents chat theme.
  final VBaseMessageTheme theme;

  static VInheritedMessageTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VInheritedMessageTheme>();

  @override
  bool updateShouldNotify(VInheritedMessageTheme oldWidget) =>
      theme.hashCode != oldWidget.theme.hashCode;
}
