import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:v_chat_room_page/src/shared/extentions.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class RoomState {
  final Future<VRoom?> Function(String roomId) getRoom;

  RoomState(this.getRoom);

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

  void close() {
    roomNotifier.dispose();
    roomStateStream.close();
  }

  VRoom? roomById(String roomId) =>
      stateRooms.firstWhereOrNull((e) => e.id == roomId);

  void blockSingle(String roomId, VSingleBanModel banModel) {}

  void updateOnlineOrOff(String roomId, VOnlineOfflineModel model) {
    final room = roomById(roomId);
    if (room != null) {
      room.isOnline = model.isOnline;
      roomStateStream.sink.add(room);
    }
  }

  void setTyping(String roomId, VSocketRoomTypingModel typingModel) {
    final room = roomById(roomId);
    if (room != null) {
      room.typingStatus = typingModel;
      roomStateStream.sink.add(room);
    }
  }

  void updateName(String roomId, String name) {
    final room = roomById(roomId);
    if (room != null) {
      room.title = name;
      roomStateStream.sink.add(room);
    }
  }

  void updateImage(String roomId, String image) {
    final room = roomById(roomId);
    if (room != null) {
      room.thumbImage = VFullUrlModel(image);
      roomStateStream.sink.add(room);
    }
  }

  void addUnReadOne(String roomId) {
    final room = roomById(roomId);
    if (room != null) {
      room.unReadCount = ++room.unReadCount;
      roomStateStream.sink.add(room);
    }
  }

  void resetRoomCounter(String roomId) {
    final room = roomById(roomId);
    if (room != null) {
      room.unReadCount = 0;
      roomStateStream.sink.add(room);
    }
  }

  void updateMute(String roomId, bool isMuted) {
    final room = roomById(roomId);
    if (room != null) {
      room.isMuted = isMuted;
      roomStateStream.sink.add(room);
    }
  }

  void deleteRoom(String roomId) {
    final room = roomById(roomId);
    if (room != null) {
      room.isDeleted = true;
      roomStateStream.sink.add(room);
    }
  }

  void onDeleteMessage(VDeleteMessageEvent event) {
    final room = roomById(event.roomId);
    if (room != null && room.lastMessage.localId == event.localId) {
      if (event.upMessage != null) {
        room.lastMessage = event.upMessage!;
      } else {
        room.lastMessage.isDeleted = true;
      }
      roomStateStream.sink.add(room);
    }
  }

  void onDeliverAllMgs(VUpdateMessageDeliverEvent event) {
    final room = roomById(event.roomId);
    if (room != null) {
      room.lastMessage.deliveredAt = event.model.date;
      roomStateStream.sink.add(room);
    }
  }

  void onSeenAllMgs(VUpdateMessageSeenEvent event) {
    final room = roomById(event.roomId);
    if (room != null) {
      room.lastMessage.seenAt = event.model.date;
      room.lastMessage.deliveredAt ??= event.model.date;
      roomStateStream.sink.add(room);
    }
  }

  void onUpdateMsg(VUpdateMessageEvent event) {
    final room = roomById(event.roomId);
    if (room != null && room.lastMessage.localId == event.localId) {
      room.lastMessage = event.messageModel;
      roomStateStream.sink.add(room);
    }
  }

  void onUpdateMsgStatus(VUpdateMessageStatusEvent event) {
    final room = roomById(event.roomId);
    if (room != null && room.lastMessage.localId == event.localId) {
      room.lastMessage.messageStatus = event.emitState;
      roomStateStream.sink.add(room);
    }
  }

  void onUpdateMsgType(VUpdateMessageTypeEvent event) {
    final room = roomById(event.roomId);
    if (room != null && room.lastMessage.localId == event.localId) {
      room.lastMessage.messageType = event.messageType;
      roomStateStream.sink.add(room);
    }
  }

  void onNewMsg(VInsertMessageEvent event) async {
    final room = roomById(event.roomId);
    if (room != null) {
      room.lastMessage = event.messageModel;
      stateRooms.sortByMsgId();
      roomNotifier.notifyListeners();
    } else {
      //we need to request this room !
      //first search in local db
      //if not found then send api request to server
      await Future.delayed(const Duration(seconds: 1));
      final newRoom = await getRoom(event.roomId);
      if (newRoom != null) {
        insertRoom(newRoom);
      }
    }
  }
}
