import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk/src/services/vchat_app_service.dart';
import '../../../enums/load_more_type.dart';
import '../../../enums/room_type.dart';
import '../../../models/vchat_room.dart';
import '../../../models/vchat_room_typing.dart';
import '../../../services/local_storage_serivce.dart';
import '../../../utils/custom_widgets/custom_alert_dialog.dart';
import '../providers/room_api_provider.dart';


class RoomController extends GetxController {

  final _provider = Get.find<RoomsApiProvider>();
  VchatRoom? currentRoom;
  final rooms = <VchatRoom>[].obs;
  final isLoading = true.obs;
  final RxInt totalUnreadMessages = 0.obs;
  final loadingStatus = LoadMoreStatus.loaded.obs;
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    getAllRooms();
  }

  void getAllRooms() async {
    final x = await Get.find<LocalStorageService>().getRooms();
    rooms.assignAll(x);
    isLoading.value = false;
  }

  void loadMore() async {
    final loadedRooms = await _provider.loadMore(rooms.last.id);
    loadingStatus.value = LoadMoreStatus.loaded;
    if (loadedRooms.isEmpty) {
      loadingStatus.value = LoadMoreStatus.completed;
    }
    rooms.addAll(loadedRooms);
  }

  void _scrollListener() async {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange &&
        loadingStatus.value != LoadMoreStatus.loading &&
        loadingStatus.value != LoadMoreStatus.completed) {
      loadingStatus.value = LoadMoreStatus.loading;
      loadMore();
    }
  }

  bool isRoomOpen(int roomId) {
    if (currentRoom == null) {
      return false;
    } else {
      if (currentRoom!.id == roomId) {
        return true;
      } else {
        return false;
      }
    }
  }

  void setCurrentRoom(int id) {
    final res = rooms.firstWhere((element) => element.id == id);
    currentRoom = res;
  }

  void blockOrLeaveAction(VchatRoom room) async {
    try {
      if (room.roomType == RoomType.groupChat) {
        await _provider.leaveGroupChat(room.id.toString());
        rooms.removeWhere((element) => element.id == room.id);
        await Get.find<LocalStorageService>().deleteRoom(room.id);
      } else {
        await _provider.blockOrUnBlock(room.ifSinglePeerId.toString());
      }
      CustomAlert.done(msg: "Done");
    } catch (err) {
      CustomAlert.error(msg: err.toString());
      rethrow;
    }
  }

  void muteAction(final VchatRoom room) async {
    try {
      final res = await _provider.changeNotifaictions(room.id);
      CustomAlert.done(msg: res.toString());
    } catch (err) {
      //  CustomAlert.customAlertDialog(errorMessage: err.toString());
      CustomAlert.error(msg: err.toString());
      rethrow;
    }
  }

  void updateOneRoomInRamAndSort(VchatRoom room) {
    final index = rooms.indexWhere((element) => element.id == room.id);
    if (index == -1) {
      rooms.insert(0, room);
    } else {
      rooms[index].isOnline.value = room.isOnline.value;
      rooms[index].lastMessage.value = room.lastMessage.value;
      rooms[index].updatedAt = room.updatedAt;
      rooms[index].lastMessageSeenBy.value = room.lastMessageSeenBy;
      rooms[index].blockerId.value = room.blockerId.value;
      rooms[index].typingStatus.value = room.typingStatus.value;
      rooms[index].isMute.value = room.isMute.value;
    }
    sort();
  }

  void sort() {
    rooms.sort((a, b) {
      return b.updatedAt.compareTo(a.updatedAt);
    });
  }

  void updateRoomOnlineChanged(int status, int roomId) {
    final room = rooms.firstWhere((element) => element.id == roomId);
    room.isOnline.value = status;
  }

  void updateRoomTypingChanged(VChatRoomTyping t) {
    final room = rooms.firstWhere((element) => element.id == t.roomId);
    room.typingStatus.value = t;
  }

  void getAllRoomsEvent(List<VchatRoom> list) {
    if (rooms.isNotEmpty) {
      for (var room in list) {
        final index = rooms.indexWhere((element) => element.id == room.id);
        if (index != -1) {
          rooms[index].isOnline.value = room.isOnline.value;
          rooms[index].lastMessage = room.lastMessage;
          rooms[index].updatedAt = room.updatedAt;
          rooms[index].lastMessageSeenBy = room.lastMessageSeenBy;
          rooms[index].blockerId = room.blockerId;
          rooms[index].typingStatus.value = room.typingStatus.value;
        } else {
          rooms.insert(0, room);
        }
      }
      sort();
    } else {
      rooms.assignAll(list);
    }
  }
}
