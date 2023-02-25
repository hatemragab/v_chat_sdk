// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../states/app_bar_state_controller.dart';
import '../states/block_state_controller.dart';
import '../states/input_state_controller.dart';
import '../states/message_state/message_state_controller.dart';

class MessageStreamState with VMessageStream, VRoomStream {
  final MessageStateController messageState;
  final AppBarStateController appBarStateController;
  final InputStateController inputStateController;
  final BlockStateController? blockStateController;
  final VNativeApi nativeApi;
  final VRoom currentRoom;

  MessageStreamState({
    required this.messageState,
    required this.nativeApi,
    required this.appBarStateController,
    required this.inputStateController,
    required this.currentRoom,
    this.blockStateController,
  }) {
    ///listen to all message
    initMessageStream(
      nativeApi.streams.messageStream.where(
        (e) => e.roomId == currentRoom.id,
      ),
    );
    initRoomStream(
      nativeApi.streams.roomStream.where(
        (e) => e.roomId == currentRoom.id,
      ),
    );
  }

  void close() {
    closeRoomStream();
    closeMessageStream();
  }

  @override
  void onNewMsg(VInsertMessageEvent event) {
    messageState.emitSeenFor(event.roomId);
    return messageState.insertMessage(event.messageModel);
  }

  /////////////// room events ////////////
  // @override
  // void onUpdateOnline(VUpdateRoomOnlineEvent event) {
  //   return appBarStateController.updateOnline(event.model.isOnline);
  // }

  @override
  void onUpdateRoomImage(VUpdateRoomImageEvent event) {
    return appBarStateController.updateImage(event.image);
  }

  @override
  void onUpdateRoomName(VUpdateRoomNameEvent event) {
    return appBarStateController.updateTitle(event.name);
  }

  @override
  void onUpdateTyping(VUpdateRoomTypingEvent event) {
    return appBarStateController.updateTyping(event.typingModel);
  }

  @override
  void onBlockRoom(VBlockRoomEvent event) {
    if (blockStateController == null) return;
    blockStateController!.updateFromRemote();
  }

  /////////////// message methods//////////
  @override
  void onDeleteMsg(VDeleteMessageEvent event) {
    return messageState.deleteMessage(event.localId);
  }

  @override
  void onGroupKicked(VOnGroupKicked event) {
    return inputStateController.closeChat();
  }

  @override
  void onDeliverAllMgs(VUpdateMessageDeliverEvent event) {
    return messageState.deliverAll(event.model);
  }

  @override
  void onSeenAllMgs(VUpdateMessageSeenEvent event) {
    return messageState.seenAll(event.model);
  }

  @override
  void onUpdateMsg(VUpdateMessageEvent event) {
    return messageState.updateMessage(event.messageModel);
  }

  @override
  void onUpdateMsgStatus(VUpdateMessageStatusEvent event) {
    return messageState.updateMessageStatus(event.localId, event.emitState);
  }

  @override
  void onUpdateMsgType(VUpdateMessageTypeEvent event) {
    return messageState.updateMessageType(event.localId, event.messageType);
  }

  @override
  void onRoomOffline(VRoomOfflineEvent event) {
    return appBarStateController.updateOffline();
  }

  @override
  void onRoomOnline(VRoomOnlineEvent event) {
    return appBarStateController.updateOnline();
  }
}
