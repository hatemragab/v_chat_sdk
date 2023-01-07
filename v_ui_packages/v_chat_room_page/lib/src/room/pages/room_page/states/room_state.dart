import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:v_chat_room_page/src/room/shared/extentions.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class RoomState extends ValueNotifier<VPaginationModel<VRoom>> {
  final Future<VRoom?> Function(String roomId) getRoom;

  RoomState(this.getRoom)
      : super(VPaginationModel<VRoom>(
          values: <VRoom>[],
          limit: 20,
          page: 1,
          nextPage: null,
        ));

  final roomStateStream = StreamController<VRoom>.broadcast();

  List<VRoom> get stateRooms => value.values;

  void updateCacheState(VPaginationModel<VRoom> paginationModel) {
    final newStateList = [...value.values];
    final apiRooms = paginationModel.values;
    for (int apiIndex = 0; apiIndex < apiRooms.length; apiIndex++) {
      final stateIndex = newStateList.indexOf(apiRooms[apiIndex]);
      if (stateIndex != -1) {
        //api room exists in local rooms we need to check if
        //local room contains sending message

        if (newStateList[stateIndex]
            .lastMessage
            .messageStatus
            .isSendingOrError) {
          final stateLastMsg = newStateList[stateIndex].lastMessage;
          newStateList[stateIndex] = apiRooms[apiIndex];
          newStateList[stateIndex].lastMessage = stateLastMsg;
        } else {
          newStateList[stateIndex] = apiRooms[apiIndex];
        }
      } else {
        newStateList.insert(0, apiRooms[apiIndex]);
      }
    }
    //we need to sort
    newStateList.sortByMsgId();
    value.values = newStateList;
    notifyListeners();
  }

  void insertRoom(VRoom room) {
    if (!stateRooms.contains(room)) {
      value.values.insert(0, room);
      notifyListeners();
    } else {
      print(
          "-------------you are try to insert message which already exist!-----------");
    }
  }

  void close() {
    dispose();
    roomStateStream.close();
  }

  VRoom? roomById(String roomId) =>
      stateRooms.firstWhereOrNull((e) => e.id == roomId);

  void blockRoom(String roomId, OnBanUserChatModel banModel) {
    final room = roomById(roomId);
    if (room != null) {
      room.blockerId = banModel.bannerId;
      // roomStateStream.sink.add(room);
    }
  }

  void updateOnline(String roomId) {
    final room = roomById(roomId);
    if (room != null) {
      room.isOnline = true;
      roomStateStream.sink.add(room);
    }
  }

  void updateOffline(String roomId) {
    final room = roomById(roomId);
    if (room != null) {
      room.isOnline = false;
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
      room.thumbImage = image;
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
      if (event.messageType.isAllDeleted) {
        room.lastMessage.messageType = event.messageType;
        final deletedMessage = VAllDeletedMessage.fromRemoteMap(
          room.lastMessage.toRemoteMap(),
        );
        room.lastMessage = deletedMessage;
        roomStateStream.sink.add(room);
      }
    }
  }

  void onNewMsg(VInsertMessageEvent event) async {
    final room = roomById(event.roomId);
    if (room != null) {
      room.lastMessage = event.messageModel;
      stateRooms.sortByMsgId();
      notifyListeners();
    } else {
      //we need to request this room !
      //first search in local db
      //if not found then send api request to server
      await Future.delayed(const Duration(seconds: 3));
      final newRoom = await getRoom(event.roomId);
      if (newRoom != null) {
        insertRoom(newRoom);
      }
    }
  }

  void insertAll(VPaginationModel<VRoom> response) {
    value.values = response.values;
    notifyListeners();
  }
}
