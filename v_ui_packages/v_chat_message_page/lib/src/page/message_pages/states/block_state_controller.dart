// // Copyright 2023, the hatemragab project author.
// // All rights reserved. Use of this source code is governed by a
// // MIT license that can be found in the LICENSE file.
//
// import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
//
// import 'input_state_controller.dart';
//
// class BlockStateController {
//   final VRoom room;
//   VSingleBlockModel value =
//       const VSingleBlockModel(isMeBanner: false, isPeerBanner: false);
//
//   BlockStateController(this.inputStateController, this.room) {
//     _getFromCache();
//     updateFromRemote();
//   }
//
//   final InputStateController inputStateController;
//
//   void updateValue(VCheckBanModel value) {
//     this.value = value;
//     if (value.isThereBan) {
//       inputStateController.closeChat();
//     } else {
//       inputStateController.openChat();
//     }
//   }
//
//   Future<void> _getFromCache() async {
//     final res = VAppPref.getMap("ban-${room.id}");
//     if (res == null) return;
//     updateValue(VSingleBlockModel .fromMap(res));
//   }
//
//   Future<void> updateFromRemote() async {
//     if (room.roomType.isSingleOrOrder) {
//       await vSafeApiCall<VSingleBlockModel>(
//         request: () {
//           return VChatController.I.blockApi
//               .checkIfThereBan(peerIdentifier: room.peerIdentifier!);
//         },
//         onSuccess: (response) async {
//           updateValue(response);
//           await VAppPref.setMap("ban-${room.id}", response.toMap());
//         },
//       );
//     }
//   }
// }
