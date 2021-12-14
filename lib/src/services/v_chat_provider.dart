import 'dart:convert';
import 'dart:io';

import 'package:v_chat_sdk/src/utils/api_utils/server_config.dart';

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

  Future<List<VChatGroupUser>> getRoomMembers(
      {required String groupId, required int paginationIndex}) async {
    final members = (await CustomDio().send(
            reqMethod: "get",
            path: "room/group-members",
            query: {"lastIndex": paginationIndex, "roomId": groupId}))
        .data['data'] as List;

    return members.map((e) => VChatGroupUser.fromMap(e)).toList();
  }

  Future updateGroupTitle(
      {required String groupId, required String title}) async {
    final res = await CustomDio().send(
      reqMethod: "post",
      path: "room/update-group-info",
      body: {"roomId": groupId, "groupName": title},
    );
  }

  Future<String> updateGroupImage(
      {required String groupId, required String path}) async {
    final file = File(path);
    if (!file.existsSync()) {
      throw VChatSdkException(
          "image file not exist in your device path is $path");
    }
    return ServerConfig.profileImageBaseUrl +
        (await CustomDio().uploadFile(
                apiEndPoint: "room/update-group-info",
                filePath: path,
                isPost: true,
                body: [
              {"roomId": groupId}
            ]))
            .data['data']['imageThumb'];
  }

  Future kickUserFromGroup(
      {required String groupId, required String kickedId}) async {
    return (await CustomDio().send(
            reqMethod: "post",
            path: "room/kick-member",
            body: {"roomId": groupId, "peerId": kickedId}))
        .data;
  }

  Future downGradeUserFromGroup(
      {required String groupId, required String userId}) async {
    return (await CustomDio().send(
            reqMethod: "post",
            path: "room/update-member-state",
            body: {"roomId": groupId, "peerId": userId, "state": "member"}))
        .data;
  }

  Future upgradeUserFromGroup(
      {required String groupId, required String userId}) async {
    return (await CustomDio().send(
            reqMethod: "post",
            path: "room/update-member-state",
            body: {"roomId": groupId, "peerId": userId, "state": "admin"}))
        .data;
  }

  Future addMembersToGroupChat(
      {required String groupId, required List<String> usersEmails}) async {
    return (await CustomDio()
            .send(reqMethod: "post", path: "room/add-member", body: {
      "roomId": groupId,
      "peersId": usersEmails,
    }))
        .data;
  }
}
