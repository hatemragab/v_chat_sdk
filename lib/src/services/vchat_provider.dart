import 'dart:convert';

import 'package:get/get.dart';

import '../enums/room_type.dart';
import '../utils/api_utils/dio/custom_dio.dart';

class VChatProvider   {
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

  Future<String> updateUserFcmToken(String token) async {
    return (await CustomDio().send(
      reqMethod: "patch",
      path: "user",
      body: {
        "fcmToken": token,
      },
    ))
        .data['data'].toString();
  }
}
