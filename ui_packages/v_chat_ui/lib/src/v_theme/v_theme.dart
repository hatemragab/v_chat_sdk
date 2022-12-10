import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_ui/src/room_page_ui/src/builder/color_builder.dart';
import 'package:v_chat_ui/src/room_page_ui/src/builder/icon_builder.dart';

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

// class VThemeDataV2 {
//   final ColorBuilder? colorBuilder;
//   final IconBuilder? iconBuilder;
//   final BuildContext context;
//
//   VThemeDataV2.dark({
//     this.colorBuilder = const ColorBuilder.dark(),
//     this.iconBuilder,
//     required this.context,
//   }) {
//     iconBuilder ??
//         IconBuilder.dark(
//           seenColor: colorBuilder!.seenMessageIconColor,
//         );
//   }
// }

class VThemeData {
  final ColorBuilder colorBuilder;
  final IconBuilder iconBuilder;
  final BuildContext context;

  VThemeData._(this.colorBuilder, this.context, this.iconBuilder);

  factory VThemeData({
    required ColorBuilder colorBuilder,
    required BuildContext context,
    required IconBuilder iconBuilder,
  }) {
    return VThemeData._(colorBuilder, context, iconBuilder);
  }

  factory VThemeData.dark({
    required BuildContext context,
  }) =>
      VThemeData(
        colorBuilder: ColorBuilder.dark(),
        context: context,
        iconBuilder: IconBuilder.dark(),
      );

  factory VThemeData.light({
    required BuildContext context,
  }) =>
      VThemeData(
        colorBuilder: ColorBuilder.light(),
        context: context,
        iconBuilder: IconBuilder.light(),
      );

  VThemeData copyWith({
    ColorBuilder? colorBuilder,
    IconBuilder? iconBuilder,
  }) {
    return VThemeData(
      colorBuilder: colorBuilder ?? this.colorBuilder,
      iconBuilder: iconBuilder ?? this.iconBuilder,
      context: context,
    );
  }
}
