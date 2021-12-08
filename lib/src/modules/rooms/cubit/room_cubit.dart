import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:v_chat_sdk/src/enums/load_more_type.dart';
import 'package:v_chat_sdk/src/utils/helpers/helpers.dart';
import '../../../enums/room_type.dart';
import '../../../models/v_chat_room.dart';
import '../../../models/v_chat_room_typing.dart';
import '../../../services/local_storage_service.dart';
import '../../../utils/custom_widgets/custom_alert_dialog.dart';

import '../room_api_provider.dart';

part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  RoomCubit._privateConstructor() : super(RoomInitial()) {
    getRoomsFromLocal();
  }

  static final RoomCubit instance = RoomCubit._privateConstructor();
  Function(String? uniqueId)? onMessageAvatarPressed;

  final _provider = RoomsApiProvider();

  final rooms = <VChatRoom>[];
  int loadMorePage = 1;

  LoadMoreStatus loadingStatus = LoadMoreStatus.loaded;

  final scrollController = ScrollController();
  String? currentRoomId;

  Future getRoomsFromLocal() async {
    final rooms = await LocalStorageService.instance.getRooms();
    this.rooms.clear();
    this.rooms.addAll(rooms);
    emit(RoomLoaded(this.rooms));
  }

  void setSocketRooms(List<VChatRoom> rooms) {
    this.rooms.clear();
    this.rooms.addAll(rooms);
    emit(RoomLoaded(this.rooms));
  }

  void updateRoomOnlineChanged(int status, String roomId) {
    final index = rooms.indexWhere((element) => element.id == roomId);
    if (index != -1) {
      final room = rooms[index];
      rooms.removeAt(index);
      rooms.insert(index, room.copyWith(isOnline: status));
    }
    emit(RoomLoaded(rooms));
  }

  void updateRoomTypingChanged(VChatRoomTyping t) {
    final index = rooms.indexWhere((element) => element.id == t.roomId);
    if (index != -1) {
      final room = rooms[index];
      rooms.removeAt(index);
      rooms.insert(index, room.copyWith(typingStatus: t));
    }
    emit(RoomLoaded(rooms));
  }

  Future<void> loadMore() async {
    final loadedRooms = await _provider.loadMore(loadMorePage);
    loadingStatus = LoadMoreStatus.loaded;
    if (loadedRooms.isEmpty) {
      loadingStatus = LoadMoreStatus.completed;
    }
    ++loadMorePage;
    rooms.addAll(loadedRooms);
    emit(RoomLoaded(rooms));
  }

  bool isRoomOpen(String roomId) => currentRoomId == roomId;

  void blockOrLeaveAction(BuildContext context, VChatRoom room) async {
    try {
      if (room.roomType == RoomType.groupChat) {
        CustomAlert.error(msg: "Coming Soon");
        // await _provider.leaveGroupChat(room.id.toString());
        // rooms.removeWhere((element) => element.id == room.id);
        // await LocalStorageService.instance.deleteRoom(room.id);
      } else {
        await _provider.blockOrUnBlock(room.ifSinglePeerId.toString());
      }
      CustomAlert.done(context: context);
    } catch (err) {
      CustomAlert.error(msg: err.toString());
      rethrow;
    }
  }

  void muteAction(BuildContext context, final VChatRoom room) async {
    try {
      ///socket will take car of update the ui
      await _provider.changeNotifaictions(room.id);

      CustomAlert.done(context: context);
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
    emit(RoomLoaded(rooms));
  }

  void setListViewListener() {
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange &&
        loadingStatus != LoadMoreStatus.loading &&
        loadingStatus != LoadMoreStatus.completed) {
      loadingStatus = LoadMoreStatus.loading;
      loadMore();
    }
  }

  @override
  Future<void> close() async {
    scrollController.dispose();
    super.close();
  }

  VChatRoom getRoomById(String roomId) {
    return rooms.firstWhere((element) => element.id == roomId);
  }
}
