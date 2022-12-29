import 'package:v_chat_room_page/src/pages/room_page/room_state.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class LocalStreamChanges with VMessageStream, VRoomStream {
  final RoomState roomState;
  final VNativeApi nativeApi;

  LocalStreamChanges({
    required this.roomState,
    required this.nativeApi,
  }) {
    initMessageStream(nativeApi.local.message.messageStream);
    initRoomStream(nativeApi.local.room.roomStream);
  }

  void close() {
    closeRoomStream();
    closeMessageStream();
  }

  @override
  onNewMsg(VInsertMessageEvent event) {}

  /////////////// room events ////////////
  @override
  void onUpdateOnline(VUpdateRoomOnlineEvent event) {
    return roomState.updateOnlineOrOff(event.roomId, event.model);
  }

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

  @override
  void onBlockSingleRoom(VBlockSingleRoomEvent event) {
    return roomState.blockSingle(event.roomId, event.banModel);
  }

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
  void onDeleteMsg(VDeleteMessageEvent event) {
    // TODO: implement onDeleteMsg
  }

  @override
  void onDeliverAllMgs(VUpdateMessageDeliverEvent event) {
    // TODO: implement onDeliverAllMgs
  }

  @override
  void onSeenAllMgs(VUpdateMessageSeenEvent event) {
    // TODO: implement onSeenAllMgs
  }

  @override
  void onUpdateMsg(VUpdateMessageEvent event) {
    // TODO: implement onUpdateMsg
  }

  @override
  void onUpdateMsgStatus(VUpdateMessageStatusEvent event) {
    // TODO: implement onUpdateMsgStatus
  }

  @override
  void onUpdateMsgType(VUpdateMessageTypeEvent event) {
    // TODO: implement onUpdateMsgType
  }
}
