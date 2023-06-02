// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// A singleton class that tracks all open rooms.
///
/// For any message received from server, this class checks if the room is open.
/// If the room is open, it stops the message notification.
/// When you open a room, you must call [addToOpenRoom].
/// When you close a room, you must call [closeOpenedRoom].
class VRoomTracker {
  final _currentOpenRooms = <CurrentRoom>[];

  VRoomTracker._();

  /// Returns the singleton instance of [VRoomTracker].
  static final instance = VRoomTracker._();

  /// Checks if the room identified by [roomId] is open.
  ///
  /// Returns `true` if the room is open, `false` otherwise.
  bool isRoomOpen(String roomId) {
    final i = _currentOpenRooms.indexWhere((e) => e.roomId == roomId);
    if (i == -1) return false;
    return _currentOpenRooms[i].isActive;
  }

  /// Adds a room identified by [roomId] to the list of open rooms.
  void addToOpenRoom({required String roomId}) {
    _currentOpenRooms.add(CurrentRoom(isActive: true, roomId: roomId));
  }

  /// Removes the room identified by [roomId] from the list of open rooms.
  void closeOpenedRoom(String roomId) {
    _currentOpenRooms.removeWhere((e) => e.roomId == roomId);
  }

  /// Sets a room to inactive state.
  ///
  /// [currentRoom] is the room to be set to inactive.

  void setRoomInActive(CurrentRoom currentRoom) {
    final i = _currentOpenRooms.indexOf(currentRoom);
    _currentOpenRooms[i].isActive = false;
  }

  /// Sets a room to active state.
  ///
  /// [currentRoom] is the room to be set to active.
  void setRoomActive(CurrentRoom currentRoom) {
    final i = _currentOpenRooms.indexOf(currentRoom);
    _currentOpenRooms[i].isActive = true;
  }
}
