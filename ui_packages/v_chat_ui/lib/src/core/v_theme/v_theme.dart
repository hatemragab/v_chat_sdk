import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_ui/src/core/v_theme/v_theme_data.dart';

class VTheme extends InheritedWidget {
  final VThemeData dataLight;
  final VThemeData dataDark;
  final Brightness brightness;

  const VTheme({
    super.key,
    required Widget child,
    required this.brightness,
    required this.dataLight,
    required this.dataDark,
  }) : super(child: child);

  @override
  bool updateShouldNotify(VTheme oldWidget) => dataLight != oldWidget.dataLight;

  static VTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VTheme>();

  VThemeData get vThemeData {
    if (brightness == Brightness.dark) {
      return dataDark;
    }
    return dataLight;
  }
}
