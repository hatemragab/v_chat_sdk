// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:v_chat_room_page/src/room/pages/room_page/room_provider.dart';
import 'package:v_chat_room_page/src/room/shared/extentions.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class RoomStateController extends ValueNotifier<VPaginationModel<VRoom>> {
  final RoomProvider _roomProvider;
  bool isFinishLoadMore = false;
  bool _isLoadMoreActive = false;

  RoomStateController(this._roomProvider)
      : super(
          VPaginationModel<VRoom>(
            values: <VRoom>[],
            limit: 20,
            page: 2,
            nextPage: null,
          ),
        );

  final roomStateStream = StreamController<VRoom>.broadcast(sync: true);

  List<VRoom> get stateRooms => value.values;

  void updateCacheState(VPaginationModel<VRoom> paginationModel) {
    final newStateList = [...value.values];
    final apiRooms = paginationModel.values;
    for (int apiIndex = 0; apiIndex < apiRooms.length; apiIndex++) {
      final stateIndex = newStateList.indexOf(apiRooms[apiIndex]);
      if (stateIndex != -1) {
        //api room exists in local rooms we need to check if
        //local room contains sending message
        if (newStateList[stateIndex].lastMessage.emitStatus.isSendingOrError) {
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
    } else {
      if (room.isDeleted) {
        room.isDeleted = false;
      }
      if (kDebugMode) {
        print(
            "-------------you are try to insert message which already exist!-----------");
      }
    }
    notifyListeners();
  }

  void close() {
    dispose();
    roomStateStream.close();
  }

  VRoom? roomById(String roomId) =>
      stateRooms.firstWhereOrNull((e) => e.id == roomId);

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

  void updateTyping(String roomId, VSocketRoomTypingModel typingModel) {
    final room = roomById(roomId);
    if (room != null) {
      room.typingStatus = typingModel;
      roomStateStream.sink.add(room);
    }
  }

  void updateTitle(String roomId, String title) {
    final room = roomById(roomId);
    if (room != null) {
      room.title = title;
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

  void updateCounterByOne(String roomId) {
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

  void deleteRoomLastMessage(VDeleteMessageEvent event) {
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

  void deliverRoomLastMessage(VUpdateMessageDeliverEvent event) {
    final room = roomById(event.roomId);
    if (room != null) {
      room.lastMessage.deliveredAt = event.model.date;
      roomStateStream.sink.add(room);
    }
  }

  void seenRoomLastMessage(VUpdateMessageSeenEvent event) {
    final room = roomById(event.roomId);
    if (room != null) {
      room.lastMessage.seenAt = event.model.date;
      room.lastMessage.deliveredAt ??= event.model.date;
      roomStateStream.sink.add(room);
    }
  }

  void updateRoomLastMessageAllDelete(VUpdateMessageAllDeletedEvent event) {
    final room = roomById(event.roomId);
    if (room != null && room.lastMessage.localId == event.localId) {
      room.lastMessage.allDeletedAt = event.message.allDeletedAt;
      roomStateStream.sink.add(room);
    }
  }

  void updateRoomLastMessageStatus(VUpdateMessageStatusEvent event) {
    final room = roomById(event.roomId);
    if (room != null && room.lastMessage.localId == event.localId) {
      room.lastMessage.emitStatus = event.emitState;
      roomStateStream.sink.add(room);
    }
  }

  void updateRoomLastMessage(VUpdateMessageEvent event) {
    final room = roomById(event.roomId);
    if (room != null && room.lastMessage.localId == event.localId) {
      room.lastMessage = event.messageModel;
      roomStateStream.sink.add(room);
    }
  }

  void insertRoomLastMessage(VInsertMessageEvent event) async {
    final room = roomById(event.roomId);
    if (room != null) {
      room.isDeleted = false;
      room.lastMessage = event.messageModel;
      stateRooms.sortByMsgId();
      notifyListeners();
    } else {
      final localRoom = await _roomProvider.getLocalRoomById(event.roomId);
      if (localRoom != null) {
        insertRoom(localRoom);
      }
    }
  }

  void insertAll(VPaginationModel<VRoom> response) {
    value.values = response.values;
    notifyListeners();
  }

  Future<bool> onLoadMore() async {
    if (_isLoadMoreActive) {
      return false;
    }
    final res = await vSafeApiCall<VPaginationModel<VRoom>>(
      onLoading: () {
        _isLoadMoreActive = true;
      },
      request: () async {
        print("start loadmore to page ${value.page}");
        return _roomProvider.getApiRooms(
          VRoomsDto(page: value.page, limit: 20),
          deleteOnEmpty: false,
        );
      },
      onSuccess: (response) {
        ++value.page;
        if (response.values.isEmpty) {
          isFinishLoadMore = true;
        }
        for (final e in response.values) {
          if (!value.values.contains(e)) {
            value.values.add(e);
          }
        }
        value.values.sortByMsgId();
        notifyListeners();
        _isLoadMoreActive = false;
        print("_isLoadMoreActive_isLoadMoreActive ${response.values.length}");
      },
      onError: (exception, trace) {
        print(exception);
        print(trace);
        _isLoadMoreActive = false;
      },
    );
    if (res == null || res.values.isEmpty) {
      return false;
    }
    return true;
  }

  void sortRoomsBy(VRoomType type) {
    switch (type) {
      case VRoomType.s:
        value.values = value.values.where((e) => e.roomType.isSingle).toList();
        notifyListeners();
        break;
      case VRoomType.g:
        value.values = value.values.where((e) => e.roomType.isGroup).toList();
        notifyListeners();
        break;
      case VRoomType.b:
        value.values =
            value.values.where((e) => e.roomType.isBroadcast).toList();
        notifyListeners();
        break;
      case VRoomType.o:
        value.values = value.values.where((e) => e.roomType.isOrder).toList();
        notifyListeners();
        break;
    }
  }

  void setRoomSelected(String roomId) {
    //first un select
    for (int i = 0; i < value.values.length; i++) {
      if (value.values[i].isSelected) {
        value.values[i].isSelected = false;
        roomStateStream.sink.add(value.values[i]);
      }
    }
    final room = roomById(roomId);
    if (room != null) {
      room.isSelected = true;
      roomStateStream.sink.add(room);
    }
  }
}
