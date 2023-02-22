// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_room_page/src/room/pages/room_page/states/room_state_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class RoomStreamState with VMessageStream, VRoomStream, VSocketIntervalStream {
  final RoomStateController roomState;
  final VNativeApi nativeApi;

  RoomStreamState({
    required this.roomState,
    required this.nativeApi,
  }) {
    initMessageStream(nativeApi.streams.messageStream);
    initRoomStream(nativeApi.streams.roomStream);
    // test();
    initSocketIntervalStream(
      nativeApi.streams.socketIntervalStream,
    );
  }

  // test() async {
  //   await Future.delayed(Duration(seconds: 3));
  //   onUpdateOnline(VUpdateRoomOnlineEvent(
  //     roomId: 'rid1',
  //     model: VOnlineOfflineModel(isOnline: true, peerId: "asd"),
  //   ));
  // }

  void close() {
    closeRoomStream();
    closeMessageStream();
    closeSocketIntervalStream();
  }

  /////////////// room events ////////////
  // @override
  // void onUpdateOnline(VUpdateRoomOnlineEvent event) {
  //   return roomState.updateOnlineOrOff(event.roomId, event.model);
  // }

  @override
  void onUpdateRoomImage(VUpdateRoomImageEvent event) {
    return roomState.updateImage(event.roomId, event.image);
  }

  @override
  void onUpdateRoomName(VUpdateRoomNameEvent event) {
    return roomState.updateName(event.roomId, event.name);
  }

  @override
  void onUpdateTyping(VUpdateRoomTypingEvent event) {
    return roomState.setTyping(event.roomId, event.typingModel);
  }

  @override
  void onAddOneToUnRead(VUpdateRoomUnReadCountByOneEvent event) {
    return roomState.addUnReadOne(event.roomId);
  }

  // @override
  // void onBlockRoom(VBlockRoomEvent event) {
  //   return roomState.blockRoom(event.roomId, event.banModel);
  // }

  @override
  void onChangeMute(VUpdateRoomMuteEvent event) {
    return roomState.updateMute(event.roomId, event.isMuted);
  }

  @override
  void onDeleteRoom(VDeleteRoomEvent event) {
    return roomState.deleteRoom(event.roomId);
  }

  @override
  void onInsertRoom(VInsertRoomEvent event) {
    return roomState.insertRoom(event.room);
  }

  @override
  void onResetRoomCounter(VUpdateRoomUnReadCountToZeroEvent event) {
    return roomState.resetRoomCounter(event.roomId);
  }

  /////////////// message methods//////////
  @override
  void onNewMsg(VInsertMessageEvent event) {
    return roomState.onNewMessage(event);
  }

  @override
  void onDeleteMsg(VDeleteMessageEvent event) {
    return roomState.onDeleteMessage(event);
  }

  @override
  void onDeliverAllMgs(VUpdateMessageDeliverEvent event) {
    return roomState.onDeliverAllMgs(event);
  }

  @override
  void onSeenAllMgs(VUpdateMessageSeenEvent event) {
    return roomState.onSeenAllMgs(event);
  }

  @override
  void onUpdateMsg(VUpdateMessageEvent event) {
    return roomState.onUpdateMsg(event);
  }

  @override
  void onUpdateMsgStatus(VUpdateMessageStatusEvent event) {
    return roomState.onUpdateMsgStatus(event);
  }

  @override
  void onUpdateMsgType(VUpdateMessageTypeEvent event) {
    return roomState.onUpdateMsgType(event);
  }

  @override
  void onIntervalFire() {
    final ids = roomState.stateRooms
        .where((element) => element.roomType.isSingle)
        .toList();
    nativeApi.remote.socketIo.emitGetMyOnline(
      ids
          .map((e) => VOnlineOfflineModel(
                peerId: e.peerId!,
                isOnline: false,
                roomId: e.id,
              ))
          .toList(),
    );
  }

  @override
  void onRoomOffline(VRoomOfflineEvent event) {
    return roomState.updateOffline(event.roomId);
  }

  @override
  void onRoomOnline(VRoomOnlineEvent event) {
    return roomState.updateOnline(event.roomId);
  }
}
