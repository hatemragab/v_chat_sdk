import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../assets/data/api_rooms.dart';
import '../../assets/data/local_rooms.dart';

class RoomProvider {
  final _localRoom = VChatController.I.nativeApi.local.room;
  final _remoteRoom = VChatController.I.nativeApi.remote.remoteRoom;

  Future<List<VRoom>> getFakeLocalRooms() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return [VRoom.fromLocalMap(fakeLocalRooms.first)];
  }

  Future<List<VRoom>> getFakeApiRooms() async {
    await Future.delayed(const Duration(milliseconds: 1100));
    return [VRoom.fromMap(fakeApiRooms.first)];
  }

  Future<VPaginationModel> getApiRooms(VPaginationModel paginationModel) async {
    return _remoteRoom.getRooms(paginationModel);
  }

  Future<VRoom?> searchForRoom(String roomId) async {
    final localRoom = await _localRoom.getRoomById(roomId);
    if (localRoom != null) {
      return localRoom;
    }
    final apiRoom = await _remoteRoom.getRoomById(roomId);
    await _localRoom.safeInsertRoom(apiRoom);
    return null;
  }
}
