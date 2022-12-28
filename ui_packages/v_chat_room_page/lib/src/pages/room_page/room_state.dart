import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:v_chat_room_page/src/shared/extentions.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class RoomState {
  final roomStateStream = StreamController<VRoom>.broadcast();
  final roomNotifier = ValueNotifier<VPaginationModel<VRoom>>(
    VPaginationModel<VRoom>(
      values: <VRoom>[],
      limit: 20,
      page: 1,
      nextPage: null,
    ),
  );

  List<VRoom> get stateRooms => roomNotifier.value.values;

  void updateCacheState(List<VRoom> apiRooms) {
    for (int i = 0; i < apiRooms.length; i++) {
      final stateRoomIndex = stateRooms.indexOf(apiRooms[i]);
      if (stateRoomIndex != -1) {
        //api room exists in local rooms we need to check if
        //local room contains sending message
        if (stateRooms[i].lastMessage.messageStatus.isSendingOrError) {
          apiRooms[i].lastMessage = stateRooms[i].lastMessage;
        }
      }
    }
    //we need to sort
    roomNotifier.value.values = apiRooms.sortByMsgId();
    roomNotifier.notifyListeners();
  }

  void insertRoom(VRoom room) {
    if (!stateRooms.contains(room)) {
      roomNotifier.value.values.insert(0, room);
      roomNotifier.notifyListeners();
    } else {
      print(
          "-------------you are try to insert message which already exist!-----------");
    }
  }

  void updateRoom() {}

  void close() {
    roomNotifier.dispose();
    roomStateStream.close();
  }
}
