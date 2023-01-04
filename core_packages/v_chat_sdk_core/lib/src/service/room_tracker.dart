import '../../v_chat_sdk_core.dart';

class VRoomTracker {
  VRoomTracker._();

  static final instance = VRoomTracker._();
  final _currentOpenRooms = <CurrentRoom>[];

  bool isRoomOpen(String roomId) {
    final i = _currentOpenRooms.indexWhere((e) => e.roomId == roomId);
    if (i == -1) return false;
    return _currentOpenRooms[i].isActive;
  }

  void addToOpenRoom({
    required String roomId,
  }) {
    _currentOpenRooms.add(
      CurrentRoom(
        isActive: true,
        roomId: roomId,
      ),
    );
  }

  void closeOpenedRoom(String roomId) {
    _currentOpenRooms.removeWhere(
      (e) => e.roomId == roomId,
    );
  }

  void setRoomInActive(CurrentRoom currentRoom) {
    final i = _currentOpenRooms.indexOf(currentRoom);
    _currentOpenRooms[i].isActive = false;
  }

  void setRoomActive(CurrentRoom currentRoom) {
    final i = _currentOpenRooms.indexOf(currentRoom);
    _currentOpenRooms[i].isActive = true;
  }
}
