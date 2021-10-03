import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import '../../../models/vchat_user.dart';
import '../../../utils/api_utils/dio/custom_dio.dart';
import '../../../utils/api_utils/dio/server_default_res.dart';
import '../dto/create_single_room_dto.dart';

class CreateSingleChatProvider extends DisposableInterface {
  Future<List<VChatUser>> getUsers(int lastUserId) async {
    final usersMapList = (await CustomDio().send(
            reqMethod: "GET",
            path: "user",
            query: {"id": lastUserId.toString()}))
        .data['data'] as List;
    return usersMapList.map((e) => VChatUser.fromMapAllUsersPage(e)).toList();
  }

  Future<ServerDefaultResponse> checkIfThereRoom(int peerId) async {
    final map = (await CustomDio().send(
      reqMethod: "POST",
      path: "room/check-if-there-room",
      body: {
        "usersIdsJson": jsonEncode([peerId])
      },
    ))
        .data;
    return ServerDefaultResponse.fromMap(map);
  }

  Future<ServerDefaultResponse> createNewSingleRoom(
      CreateSingleRoomDto dto) async {
    final map = (await CustomDio().send(
      reqMethod: "POST",
      path: "room",
      body: dto.toMap(),
    ))
        .data;
    return ServerDefaultResponse.fromMap(map);
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    log("CreateSingleChatProvider closed !!!!!!!!!!!!!!!!");
  }
}
