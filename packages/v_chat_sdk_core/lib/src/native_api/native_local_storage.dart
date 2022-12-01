// import '../../v_chat_sdk_core.dart';
// import '../local_db/local_storage_service.dart';
//
// mixin NativeLocalStorage {
//   final _localStorage = LocalStorageService.instance;
//
//   Future<List<VBaseMessage>> getLocalRoomMessages(String roomId) async {
//     return _localStorage.getRoomMessages(roomId);
//   }
//
//   Future<List<VBaseRoom>> getLocalRooms({int limit = 300}) async {
//     return _localStorage.getRooms(limit: limit);
//   }
//
//   Future<List<VBaseRoom>> searchLocalRooms({
//     required String text,
//     int limit = 20,
//   }) async {
//     return _localStorage.searchRoom(limit: limit, text: text);
//   }
// }
