// import 'package:flutter/material.dart';
// import 'package:v_chat_utils/v_chat_utils.dart';
//
// import '../../v_chat_message_page.dart';
//
// typedef CustomMessageItemTypeDef = Widget Function(
//   BuildContext context,
//   bool isMeSender,
//   Map<String, dynamic> data,
// );
// typedef ItemHolderColorTypeDef = Color Function(
//   BuildContext context,
//   bool isMeSender,
//   bool isDarkMode,
// );
//
// const _darkMeSenderColor = Colors.indigo;
// const _darkReceiverColor = Color(0xff515156);
//
// const _lightReceiverColor = Color(0xffffffff);
// const _lightMySenderColor = Colors.blue;
//
// const _lightTextMeSenderColor = TextStyle(
//   color: Colors.white,
//   fontSize: 16,
//   fontWeight: FontWeight.normal,
// );
// const _lightTextMeReceiverColor = TextStyle(
//   color: Colors.black,
//   fontSize: 16,
//   fontWeight: FontWeight.normal,
// );
//
// const _darkTextMeSenderColor = TextStyle(
//   color: Colors.white,
//   fontSize: 16,
//   fontWeight: FontWeight.normal,
// );
// const _darkTextReceiverColor = TextStyle(
//   color: Colors.white,
//   fontSize: 16,
//   fontWeight: FontWeight.normal,
// );
//
// abstract class VBaseMessageTheme {
//   /// Used as a background color of a chat widget.
//   final Color bubbleMeSenderColor;
//   final Color bubbleMeReceiverColor;
//   final VMsgStatusTheme messageSendingStatus;
//   final BoxDecoration scaffoldDecoration;
//   final CustomMessageItemTypeDef? customMessageItem;
//   final TextStyle receiverTextStyle;
//   final TextStyle senderTextStyle;
//   final BoxDecoration? messageItemHolderDecoration;
//
//   const VBaseMessageTheme({
//     required this.bubbleMeSenderColor,
//     required this.bubbleMeReceiverColor,
//     required this.senderTextStyle,
//     this.customMessageItem,
//     required this.scaffoldDecoration,
//     required this.messageSendingStatus,
//     required this.receiverTextStyle,
//     this.messageItemHolderDecoration,
//   });
// }
//
// class VLightMessageTheme extends VBaseMessageTheme {
//   const VLightMessageTheme({
//     super.bubbleMeSenderColor = _lightMySenderColor,
//     super.bubbleMeReceiverColor = _lightReceiverColor,
//     super.senderTextStyle = _lightTextMeSenderColor,
//     super.receiverTextStyle = _lightTextMeReceiverColor,
//     super.messageSendingStatus = const VMsgStatusTheme.light(),
//     super.scaffoldDecoration = const BoxDecoration(color: Color(0xffeee4e4)),
//   });
// }
//
// class VDarkMessageTheme extends VBaseMessageTheme {
//   const VDarkMessageTheme({
//     super.bubbleMeSenderColor = _darkMeSenderColor,
//     super.bubbleMeReceiverColor = _darkReceiverColor,
//     super.senderTextStyle = _darkTextMeSenderColor,
//     super.receiverTextStyle = _darkTextReceiverColor,
//     super.messageSendingStatus = const VMsgStatusTheme.dark(),
//     super.scaffoldDecoration = const BoxDecoration(),
//   });
// }
//
// extension VMessageThemeNewExt on BuildContext {
//   VBaseMessageTheme get vMessageTheme {
//     if (VInheritedMessageTheme.of(this) == null) {
//       if (isDark) {
//         return const VDarkMessageTheme();
//       } else {
//         return const VLightMessageTheme();
//       }
//     }
//     return VInheritedMessageTheme.of(this)!.currentTheme(isDark);
//   }
//
//   Color getMessageItemHolderColor(
//     bool isSender,
//   ) {
//     if (isDark && isSender) {
//       return _darkMeSenderColor;
//     } else if (isDark && !isSender) {
//       return _darkReceiverColor;
//     } else if (!isDark && isSender) {
//       return _lightMySenderColor;
//     } else {
//       return _lightReceiverColor;
//     }
//   }
// }
