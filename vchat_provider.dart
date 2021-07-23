import 'dart:convert';

import 'app/enums/room_type.dart';
import 'app/utils/api_utils/dio/custom_dio.dart';

class VChatProvider {
  Future createSingleChat(String peerEmail) async {
  return (await CustomDio().send(
      reqMethod: "POST",
      path: "room/check-if-there-room",
      body: {
        "peerEmails": jsonEncode([peerEmail]),
        "roomType": RoomType.single.inString
      },
    ))
        .data['data'];
  }

  Future createNewSingleRoom(String msg, String peerEmail) async {
   return (await CustomDio().send(
      reqMethod: "POST",
      path: "room",
      body: {
        "peerEmails": jsonEncode([peerEmail]),
        "roomType": RoomType.single.inString,
        "message": msg,
      },
    ))
        .data['data'];
  }
}
