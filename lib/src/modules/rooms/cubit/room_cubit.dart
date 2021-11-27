import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../../../enums/room_type.dart';
import '../../../models/v_chat_room.dart';
import '../../../models/v_chat_room_typing.dart';
import '../../../services/local_storage_service.dart';
import '../../../utils/custom_widgets/custom_alert_dialog.dart';

import '../room_api_provider.dart';

part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  bool isLoadMoreFinished = false;



  RoomCubit._privateConstructor(): super(RoomInitial());

  static final RoomCubit instance = RoomCubit._privateConstructor();

  final _provider = RoomsApiProvider();



  final rooms = <VChatRoom>[];

  final scrollController = ScrollController();
  int? currentRoomId;

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

  void updateRoomOnlineChanged(int status, int roomId) {
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

  Future<bool> loadMore() async {
    if( rooms.isEmpty || rooms.length<19){
      return true;
    }
   final loadedRooms = await _provider.loadMore(rooms.last.id);
    if (loadedRooms.isEmpty) {
      isLoadMoreFinished = true;
    }
    rooms.addAll(loadedRooms);
    emit(RoomLoaded(rooms));
    return true;
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

  void blockOrLeaveAction(BuildContext context,VChatRoom room) async {
    try {
      if (room.roomType == RoomType.groupChat) {
        await _provider.leaveGroupChat(room.id.toString());
        rooms.removeWhere((element) => element.id == room.id);
        await LocalStorageService.instance.deleteRoom(room.id);
      } else {
        await _provider.blockOrUnBlock(room.ifSinglePeerId.toString());
      }
      CustomAlert.done(context: context);
    } catch (err) {
      CustomAlert.error(msg: err.toString());
      rethrow;
    }
  }

  void muteAction(BuildContext context,final VChatRoom room) async {
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
}
