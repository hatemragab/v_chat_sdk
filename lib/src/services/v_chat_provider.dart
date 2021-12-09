import 'dart:convert';
import 'dart:io';

import '../../v_chat_sdk.dart';
import '../utils/api_utils/dio/custom_dio.dart';

class VChatProvider {
  Future checkIfThereRoom(String peerEmail) async {
    return (await CustomDio().send(
      reqMethod: "POST",
      path: "room/check-if-there-room",
      body: {"peerEmail": peerEmail},
    ))
        .data['data'];
  }

  Future createNewSingleRoom(String msg, String peerEmail) async {
    return (await CustomDio().send(
      reqMethod: "POST",
      path: "room/single",
      body: {
        "peerEmail": peerEmail,
        "message": msg,
      },
    ))
        .data['data'];
  }

  Future createNewGroupRoom({required CreateGroupRoomDto dto}) async {
    return (await CustomDio().uploadFile(
      apiEndPoint: "room/group",
      isPost: true,
      filePath: dto.groupImage.path,
      body: [
        {
          "peerEmails": jsonEncode(dto.usersEmails),
        },
        {
          "title": dto.groupTitle,
        }
      ],
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
        .data['data']
        .toString();
  }

  Future<String> updateUserImage({required String path}) async {
    late String platform;
    if (Platform.isAndroid) {
      platform = "Android";
    }
    if (Platform.isIOS) {
      platform = "ios";
    }
    return (await CustomDio().uploadFile(
      filePath: path,
      isPost: false,
      body: [
        {"platform": platform}
      ],
      apiEndPoint: "user",
    ))
        .data['data']
        .toString();
  }

  Future<String> updateUserName({required String name}) async {
    late String platform;
    if (Platform.isAndroid) {
      platform = "Android";
    }
    if (Platform.isIOS) {
      platform = "ios";
    }
    return (await CustomDio().send(
      reqMethod: "patch",
      path: "user",
      body: {"name": name, "platform": platform},
    ))
        .data['data']
        .toString();
  }

  Future<String> logOut() async {
    return (await CustomDio().send(
      reqMethod: "patch",
      path: "user",
      body: {"fcmToken": "Out"},
    ))
        .data['data']
        .toString();
  }

  Future<String> getUserEmail(String id) async {
    return (await CustomDio().send(
      reqMethod: "get",
      path: "user/$id",
    ))
        .data['data']['email']
        .toString();
  }
}
