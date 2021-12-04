import '../enums/room_type.dart';
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
      path: "room",
      body: {
        "peerEmails": [peerEmail],
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
        .data['data']
        .toString();
  }

  Future<String> updateUserPassword(
      {required String oldPassword, required String newPassword}) async {
    return (await CustomDio().send(
      reqMethod: "patch",
      path: "user",
      body: {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      },
    ))
        .data['data']
        .toString();
  }

  Future<String> updateUserImage({required String path}) async {
    return (await CustomDio().uploadFile(
      filePath: path,
      isPost: false,
      apiEndPoint: "user",
    ))
        .data['data']
        .toString();
  }

  Future<String> updateUserName({required String name}) async {
    return (await CustomDio().send(
      reqMethod: "patch",
      path: "user",
      body: {"name": name},
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
