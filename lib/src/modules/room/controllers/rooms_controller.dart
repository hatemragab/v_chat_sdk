import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk/src/services/vchat_app_service.dart';
import '../../../enums/load_more_type.dart';
import '../../../enums/room_type.dart';
import '../../../models/v_chat_room.dart';
import '../../../models/v_chat_room_typing.dart';
import '../../../services/local_storage_serivce.dart';
import '../../../utils/custom_widgets/custom_alert_dialog.dart';
import '../providers/room_api_provider.dart';

class RoomController extends GetxController {
  final _provider = Get.find<RoomsApiProvider>();
  int? currentRoomId;
  final rooms = <VChatRoom>[].obs;
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
    if (currentRoomId == null) {
      return false;
    } else {
      if (currentRoomId == roomId) {
        return true;
      } else {
        return false;
      }
    }
  }


  void blockOrLeaveAction(VChatRoom room) async {
    try {
      if (room.roomType == RoomType.groupChat) {
        await _provider.leaveGroupChat(room.id.toString());
        rooms.removeWhere((element) => element.id == room.id);
        await Get.find<LocalStorageService>().deleteRoom(room.id);
      } else {
        await _provider.blockOrUnBlock(room.ifSinglePeerId.toString());
      }
      CustomAlert.done(
          msg: VChatAppService.to.getTrans().userHasBeenBlockedSuccessfully());
    } catch (err) {
      CustomAlert.error(msg: err.toString());
      rethrow;
    }
  }

  void muteAction(final VChatRoom room) async {
    try {
      final res = await _provider.changeNotifaictions(room.id);
      CustomAlert.done(msg: res.toString());
    } catch (err) {
      //  CustomAlert.customAlertDialog(errorMessage: err.toString());
      CustomAlert.error(msg: err.toString());
      rethrow;
    }
  }

  void updateOneRoomInRamAndSort(VChatRoom room) {
    final index = rooms.indexWhere((element) => element.id == room.id);
    if (index == -1) {
      rooms.insert(0, room);
    } else {
      rooms.removeAt(index);
      rooms.insert(index, room);
    }
    sort();
  }

  void sort() {
    rooms.sort((a, b) {
      return b.updatedAt.compareTo(a.updatedAt);
    });
  }

  void updateRoomOnlineChanged(int status, int roomId) {
    final index = rooms.indexWhere((element) => element.id == roomId);
    if (index != -1) {
      final room = rooms[index];
      rooms.removeAt(index);
      rooms.insert(index, room.copyWith(isOnline: status));
    }
  }

  void updateRoomTypingChanged(VChatRoomTyping t) {
    final index = rooms.indexWhere((element) => element.id == t.roomId);
    if (index != -1) {
      final room = rooms[index];
      rooms.removeAt(index);
      rooms.insert(index, room.copyWith(typingStatus: t));
    }
  }

  void getAllRoomsEvent(List<VChatRoom> list) {
    if (rooms.isNotEmpty) {
      for (final room in list) {
        final index = rooms.indexWhere((element) => element.id == room.id);
        if (index != -1) {
          rooms.removeAt(index);
          rooms.insert(index, room);
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
