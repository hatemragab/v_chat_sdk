// import 'package:flutter/widgets.dart';
//
// import '../theme/v_message_theme.dart';
//
// /// Used to make provided [MessageTheme] class available through the whole package.
// class VInheritedMessageTheme extends InheritedWidget {
//   /// Creates [InheritedWidget] from a provided [VMessageTheme] class.
//   const VInheritedMessageTheme({
//     super.key,
//     this.lightMessageTheme = const VLightMessageTheme(),
//     this.darkMessageTheme = const VDarkMessageTheme(),
//     required super.child,
//   });
//
//   /// Represents chat theme.
//   final VLightMessageTheme lightMessageTheme;
//   final VDarkMessageTheme darkMessageTheme;
//
//   static VInheritedMessageTheme? of(BuildContext context) =>
//       context.dependOnInheritedWidgetOfExactType<VInheritedMessageTheme>();
//
//   @override
//   bool updateShouldNotify(VInheritedMessageTheme oldWidget) =>
//       lightMessageTheme.hashCode != oldWidget.lightMessageTheme.hashCode ||
//       darkMessageTheme.hashCode != oldWidget.darkMessageTheme.hashCode;
//
//   VBaseMessageTheme currentTheme(bool isDark) {
//     if (isDark) {
//       return darkMessageTheme;
//     }
//     return lightMessageTheme;
//   }
// }
