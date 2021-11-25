import 'dart:async';

import '../models/v_chat_room.dart';
import '../models/v_chat_room_typing.dart';
import '../modules/rooms/cubit/room_cubit.dart';
import 'local_storage_service.dart';
import 'socket_service.dart';

class SocketController {
  // final _roomController = Get.find<RoomController>();

  late SocketService _socketService = SocketService.to;

  SocketController() {
   // injectSocketService();
  }

  void injectSocketService() async {
    await Future.delayed(const Duration(milliseconds: 150));
    _socketService = SocketService.to;
  }

  void emitTypingChange(VChatRoomTyping roomTyping) {
    _socketService.emitTypingChange(roomTyping.toMap());
  }

  void handleOnAllRoomsEvent(List<VChatRoom> list) async {
    unawaited(LocalStorageService.to.setRooms(list));
    RoomCubit.instance.setSocketRooms(list);
  }

  void handleOnUpdateOneRoomEvent(VChatRoom room) async {
    unawaited(LocalStorageService.to.setRoomOrUpdate(room));
    RoomCubit.instance.updateOneRoomInRamAndSort(room);
  }

  void handleRoomOnlineChanged(int status, int roomId) {
    RoomCubit.instance.updateRoomOnlineChanged(status, roomId);
  }

  void handleRoomTypingChanged(VChatRoomTyping t) {
    RoomCubit.instance.updateRoomTypingChanged(t);
  }
}
