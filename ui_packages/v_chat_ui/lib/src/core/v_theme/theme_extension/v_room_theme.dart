import 'package:flutter/material.dart';

class VRoomTheme extends ThemeExtension<VRoomTheme> {
  final Color color;
  final BoxDecoration decoration;
  final Widget muteIcon;
  final TextStyle titleStyle;
  final VMsgStatusTheme vMsgStatusTheme;
  final bool isDark;

  VRoomTheme._({
    required this.color,
    required this.decoration,
    required this.muteIcon,
    required this.titleStyle,
    required this.vMsgStatusTheme,
    required this.isDark,
  });

  VRoomTheme.light({
    this.color = Colors.black,
    this.decoration = const BoxDecoration(color: Colors.white),
    this.muteIcon = const Icon(Icons.notifications_off_outlined),
    this.titleStyle = const TextStyle(),
    this.vMsgStatusTheme = const VMsgStatusTheme.light(),
    this.isDark = false,
  });

  VRoomTheme.dark({
    this.color = Colors.white,
    this.decoration = const BoxDecoration(color: Colors.black12),
    this.muteIcon = const Icon(Icons.notifications_off_outlined),
    this.titleStyle = const TextStyle(),
    this.vMsgStatusTheme = const VMsgStatusTheme.dark(),
    this.isDark = true,
  });

  @override
  ThemeExtension<VRoomTheme> copyWith({
    Color? color,
    BoxDecoration? decoration,
    Widget? muteIcon,
    TextStyle? titleStyle,
    VMsgStatusTheme? vMsgStatusTheme,
    bool? isDark,
  }) {
    return VRoomTheme._(
      color: color ?? this.color,
      decoration: decoration ?? this.decoration,
      muteIcon: muteIcon ?? this.muteIcon,
      titleStyle: titleStyle ?? this.titleStyle,
      vMsgStatusTheme: vMsgStatusTheme ?? this.vMsgStatusTheme,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  ThemeExtension<VRoomTheme> lerp(ThemeExtension<VRoomTheme>? other, double t) {
    if (other is! VRoomTheme) {
      return this;
    }
    return this;
    // return VRoomTheme._(
    //   color: Color.lerp(color, other.color, t),
    //   decoration: BoxDecoration.lerp(decoration, other.decoration, t),
    //   titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
    //   muteIcon: null,
    // );
  }
}

class VMsgStatusTheme {
  final Widget pendingIcon;
  final Widget sendIcon;
  final Widget deliverIcon;
  final Widget seenIcon;
  final Widget refreshIcon;

  const VMsgStatusTheme._({
    required this.pendingIcon,
    required this.sendIcon,
    required this.deliverIcon,
    required this.seenIcon,
    required this.refreshIcon,
  });

  const VMsgStatusTheme.light({
    this.pendingIcon = const Icon(Icons.timer_outlined, color: Colors.black26),
    this.sendIcon = const Icon(Icons.done, color: Colors.black26),
    this.deliverIcon = const Icon(Icons.done_all, color: Colors.black26),
    this.seenIcon = const Icon(Icons.done_all, color: Colors.blue),
    this.refreshIcon = const Icon(Icons.refresh, color: Colors.red),
  });

  const VMsgStatusTheme.dark({
    this.pendingIcon = const Icon(Icons.timer_outlined, color: Colors.black26),
    this.sendIcon = const Icon(Icons.done, color: Colors.black26),
    this.deliverIcon = const Icon(Icons.done_all, color: Colors.black26),
    this.seenIcon = const Icon(Icons.done_all, color: Colors.blue),
    this.refreshIcon = const Icon(Icons.refresh, color: Colors.red),
  });
}
