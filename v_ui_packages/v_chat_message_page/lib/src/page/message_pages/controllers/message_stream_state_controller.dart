// // Copyright 2023, the hatemragab project author.
// // All rights reserved. Use of this source code is governed by a
// // MIT license that can be found in the LICENSE file.
//
// import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
//
// import '../states/app_bar_state_controller.dart';
// import '../states/block_state_controller.dart';
// import '../states/input_state_controller.dart';
// import '../states/message_state/message_state_controller.dart';
//
// class MessageStreamState with VMessageStream, VRoomStream {
//   final MessageStateController messageState;
//   final InputStateController inputStateController;
//   final BlockStateController? blockStateController;
//   final VNativeApi nativeApi;
//   final VRoom currentRoom;
//
//   MessageStreamState({
//     required this.messageState,
//     required this.nativeApi,
//     required this.appBarStateController,
//     required this.inputStateController,
//     required this.currentRoom,
//     this.blockStateController,
//   }) {
//     ///listen to all message
//     initMessageStream(
//       nativeApi.streams.messageStream.where(
//         (e) => e.roomId == currentRoom.id,
//       ),
//     );
//     initRoomStream(
//       nativeApi.streams.roomStream.where(
//         (e) => e.roomId == currentRoom.id,
//       ),
//     );
//   }
//
//   void close() {
//     closeRoomStream();
//     closeMessageStream();
//   }
//
//   @override
//   void onUpdateRoomImage(VUpdateRoomImageEvent event) {
//     return appBarStateController.updateImage(event.image);
//   }
//
//   @override
//   void onUpdateRoomName(VUpdateRoomNameEvent event) {
//     return appBarStateController.updateTitle(event.name);
//   }
//
//   @override
//   void onUpdateTyping(VUpdateRoomTypingEvent event) {
//     return appBarStateController.updateTyping(event.typingModel);
//   }
//
//   @override
//   void onGroupKicked(VOnGroupKicked event) {
//     return inputStateController.closeChat();
//   }
//
//   @override
//   void onBlockRoom(VBlockRoomEvent event) {
//     if (blockStateController == null) return;
//     blockStateController!.updateFromRemote();
//   }
//
//   @override
//   void onRoomOffline(VRoomOfflineEvent event) {
//     return appBarStateController.updateOffline();
//   }
//
//   @override
//   void onRoomOnline(VRoomOnlineEvent event) {
//     return appBarStateController.updateOnline();
//   }
//
//   /////////////// message methods//////////
//
//   @override
//   void onUpdateMsgType(VUpdateMessageTypeEvent event) {
//     return messageState.updateMessageType(event.localId, event.messageType);
//   }
// }
