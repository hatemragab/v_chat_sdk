// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

// import 'package:flutter/material.dart';
//
// class VVoiceThemeBuilder extends ThemeExtension<VVoiceThemeBuilder> {
//   VVoiceThemeBuilder._({
//     required this.backgroundColor,
//     required this.playIcon,
//     required this.pauseIcon,
//     required this.errorIcon,
//     required this.speedBuilder,
//   });
//
//   final Color backgroundColor;
//   final Widget playIcon;
//   final Widget pauseIcon;
//   final Widget errorIcon;
//   final Function(BuildContext context, String speed) speedBuilder;
//
//   factory VVoiceThemeBuilder.light() {
//     return VVoiceThemeBuilder._(
//       backgroundColor: Colors.white70,
//       playIcon: Container(
//         height: 38,
//         width: 38,
//         decoration: const BoxDecoration(
//           color: Colors.red,
//           shape: BoxShape.circle,
//         ),
//         child: const Icon(
//           Icons.play_arrow_rounded,
//           color: Colors.white,
//         ),
//       ),
//       pauseIcon: Container(
//         height: 38,
//         width: 38,
//         decoration: const BoxDecoration(
//           color: Colors.red,
//           shape: BoxShape.circle,
//         ),
//         child: const Icon(
//           Icons.pause_rounded,
//           color: Colors.white,
//         ),
//       ),
//       errorIcon: Container(
//         height: 38,
//         width: 38,
//         decoration: const BoxDecoration(
//           color: Colors.red,
//           shape: BoxShape.circle,
//         ),
//         child: const Icon(
//           Icons.refresh,
//           color: Colors.white,
//         ),
//       ),
//       speedBuilder: (context, speed) {
//         return Container(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 3,
//             vertical: 2,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.red,
//             borderRadius: BorderRadius.circular(4),
//           ),
//           child: Text(
//             speed,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 10,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   factory VVoiceThemeBuilder.dark() {
//     return VVoiceThemeBuilder._(
//       backgroundColor: Colors.black26,
//       playIcon: Container(
//         height: 38,
//         width: 38,
//         decoration: const BoxDecoration(
//           color: Colors.red,
//           shape: BoxShape.circle,
//         ),
//         child: const Icon(
//           Icons.play_arrow_rounded,
//           color: Colors.white,
//         ),
//       ),
//       pauseIcon: Container(
//         height: 38,
//         width: 38,
//         decoration: const BoxDecoration(
//           color: Colors.red,
//           shape: BoxShape.circle,
//         ),
//         child: const Icon(
//           Icons.pause_rounded,
//           color: Colors.white,
//         ),
//       ),
//       errorIcon: Container(
//         height: 38,
//         width: 38,
//         decoration: const BoxDecoration(
//           color: Colors.red,
//           shape: BoxShape.circle,
//         ),
//         child: const Icon(
//           Icons.refresh,
//           color: Colors.white,
//         ),
//       ),
//       speedBuilder: (context, speed) {
//         return Container(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 3,
//             vertical: 2,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.red,
//             borderRadius: BorderRadius.circular(4),
//           ),
//           child: Text(
//             speed,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 10,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   ThemeExtension<VVoiceThemeBuilder> lerp(
//       ThemeExtension<VVoiceThemeBuilder>? other, double t) {
//     if (other is! VVoiceThemeBuilder) {
//       return this;
//     }
//     return this;
//   }
//
//   @override
//   VVoiceThemeBuilder copyWith({
//     Color? backgroundColor,
//     Widget? playIcon,
//     Widget? pauseIcon,
//     Widget? errorIcon,
//     Function(BuildContext context, String speed)? speedBuilder,
//   }) {
//     return VVoiceThemeBuilder._(
//       backgroundColor: backgroundColor ?? this.backgroundColor,
//       playIcon: playIcon ?? this.playIcon,
//       pauseIcon: pauseIcon ?? this.pauseIcon,
//       errorIcon: errorIcon ?? this.errorIcon,
//       speedBuilder: speedBuilder ?? this.speedBuilder,
//     );
//   }
// }
//
// extension VVoiceThemeBuilderExt on BuildContext {
//   VVoiceThemeBuilder get vVoiceMessageTheme {
//     final VVoiceThemeBuilder? theme =
//         Theme.of(this).extension<VVoiceThemeBuilder>();
//     if (theme == null) {
//       if (Theme.of(this).brightness == Brightness.dark) {
//         return VVoiceThemeBuilder.dark();
//       } else {
//         return VVoiceThemeBuilder.light();
//       }
//     }
//     return theme;
//   }
// }
