import 'dart:convert';

import '../../../enums/room_type.dart';

class CreateSingleRoomDto {
  final List<int> usersIdsJson;
  final String message;
  final RoomType roomType;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const CreateSingleRoomDto({
    required this.usersIdsJson,
    required this.message,
    required this.roomType,
  });

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'usersIdsJson': jsonEncode(usersIdsJson),
      'roomType': roomType.inString,
      'message': message,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
