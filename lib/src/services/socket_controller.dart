import 'package:get/get.dart';

import '../models/v_chat_room.dart';
import '../models/v_chat_room_typing.dart';
import '../modules/room/controllers/rooms_controller.dart';
import 'local_storage_serivce.dart';
import 'socket_service.dart';

class SocketController extends GetxController {
  final _roomController = Get.find<RoomController>();

  late SocketService _socketService;

  @override
  void onInit() {
    super.onInit();
    injectSocketService();
  }

  void injectSocketService() async {
    await Future.delayed(const Duration(milliseconds: 150));
    _socketService = Get.find<SocketService>();
  }

  void emitTypingChange(VChatRoomTyping roomTyping) {
    _socketService.emitTypingChange(roomTyping.toMap());
  }

  void handleOnAllRoomsEvent(List<VChatRoom> list) async {
    await Get.find<LocalStorageService>().setRooms(list);
    _roomController.getAllRoomsEvent(list);
  }

  void handleOnUpdateOneRoomEvent(VChatRoom room) async {
    await Get.find<LocalStorageService>().setRoomOrUpdate(room);
    _roomController.updateOneRoomInRamAndSort(room);
  }

  void handleRoomOnlineChanged(int status, int roomId) {
    _roomController.updateRoomOnlineChanged(status, roomId);
  }

  void handleRoomTypingChanged(VChatRoomTyping t) {
    _roomController.updateRoomTypingChanged(t);
  }
}
