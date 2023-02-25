// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' hide Response, Request;
import 'package:http/io_client.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

part 'channel_api.chopper.dart';

@ChopperApi(baseUrl: 'channel')
abstract class ChannelApi extends ChopperService {
  /// ----------------------------------------- single chat apis ------------------------------------------

  @Post(path: "/peer-room/{identifier}", optionalBody: true)
  Future<Response> getPeerRoom(@Path() String identifier);

  // @Post(path: "/{roomId}/close", optionalBody: true)
  // Future<Response> closeChat(
  //   @Path("roomId") String roomId,
  // );

  @Get(path: "/{roomId}")
  Future<Response> getRoomById(@Path() String roomId);

  @Patch(
    path: "/{roomId}/notification",
  )
  Future<Response> changeRoomNotification(
    @Path() String roomId,
    @Body() Map<String, dynamic> body,
  );

  ///deliver room messages
  @Patch(path: "/{roomId}/translate", optionalBody: true)
  Future<Response> transTo(
    @Path() String roomId,
    @Body() Map<String, dynamic> body,
  );

  /// translate/stop
  @Patch(path: "/{roomId}/translate/stop", optionalBody: true)
  Future<Response> stopRoomAutoTranslate(
    @Path() String roomId,
  );

  ///delete room
  @Delete(path: "/{roomId}", optionalBody: true)
  Future<Response> deleteRoom(
    @Path() String roomId,
  );

  @Get(path: "/")
  Future<Response> getRooms(@QueryMap() Map<String, dynamic> query);

  @Patch(path: "/{roomId}/deliver", optionalBody: true)
  Future<Response> deliverRoomMessages(
    @Path() String roomId,
  );

  /// ----------------------------------------- broadcast apis ------------------------------------------
  @Post(path: "/broadcast")
  @multipart
  Future<Response> createBroadcast(
    @PartMap() List<PartValue> body,
    @PartFile("file") MultipartFile? file,
  );

  @Patch(path: "/{roomId}/broadcast/title")
  Future<Response> updateBroadcastTitle(
    @Path("roomId") String roomId,
    @Body() Map<String, dynamic> body,
  );

  @Patch(path: "/{roomId}/broadcast/image")
  @multipart
  Future<Response> updateBroadcastImage(
    @Path('roomId') String roomId,
    @PartFile("file") MultipartFile file,
  );

  @Get(path: "/{roomId}/broadcast/members", optionalBody: true)
  Future<Response> getBroadcastMembers(
    @Path("roomId") String roomId,
    @QueryMap() Map<String, dynamic> query,
  );

  @Post(path: "/{roomId}/broadcast/members")
  Future<Response> addParticipantsToBroadcast(
    @Path("roomId") String roomId,
    @Body() Map<String, dynamic> body,
  );

  @Delete(path: "/{roomId}/broadcast/members/{peerId}", optionalBody: true)
  Future<Response> kickBroadcastUser(
    @Path('roomId') String roomId,
    @Path('identifier') String identifier,
  );

  @Get(path: "/{roomId}/broadcast/my-info")
  Future<Response> getMyBroadcastInfo(
    @Path("roomId") String roomId,
  );

  @Get(
    path: "/{roomId}/broadcast/message/{messageId}/status/{type}",
    optionalBody: true,
  )
  Future<Response> getMessageStatusForBroadcast(
    @Path("roomId") String roomId,
    @Path("messageId") String mId,

    ///it can be seen or deliver
    @QueryMap() Map<String, dynamic> query,
    @Path("type") String type,
  );

  /// ----------------------------------------- group apis ------------------------------------------
  @Post(path: "/group")
  @multipart
  Future<Response> createGroup(
    @PartMap() List<PartValue> body,
    @PartFile("file") MultipartFile? file,
  );

  @Post(path: "/{roomId}/group/leave", optionalBody: true)
  Future<Response> leaveGroup(@Path("roomId") String roomId);

  ///updateRoomTitle
  @Patch(path: "/{roomId}/group/title")
  Future<Response> updateGroupTitle(
    @Path("roomId") String roomId,
    @Body() Map<String, dynamic> body,
  );

  @Patch(path: "/{roomId}/group/description")
  Future<Response> updateGroupDescription(
    @Path("roomId") String roomId,
    @Body() Map<String, dynamic> body,
  );

  @Get(
    path: "/{roomId}/group/message/{messageId}/status/{type}",
    optionalBody: true,
  )
  Future<Response> getMessageStatusForGroup(
    @Path("roomId") String roomId,
    @Path("messageId") String mId,

    ///it can be seen or deliver
    @QueryMap() Map<String, dynamic> query,
    @Path("type") String type,
  );

  ///updateRoomExtra data
  @Patch(path: "/{roomId}/group/extra-data")
  Future<Response> updateGroupExtraData(
    @Path("roomId") String roomId,
    @Body() Map<String, dynamic> body,
  );

  ///updateRoomImage
  @Patch(path: "/{roomId}/group/image")
  @multipart
  Future<Response> updateGroupImage(
    @Path('roomId') String roomId,
    @PartFile("file") MultipartFile file,
  );

  @Get(path: "/{roomId}/group/my-info")
  Future<Response> getMyGroupInfo(
    @Path("roomId") String roomId,
  );

  @Get(path: "/{roomId}/group/my-status")
  Future<Response> getMyGroupStatus(
    @Path("roomId") String roomId,
  );

  ///get getGroupMembers
  @Get(path: "/{roomId}/group/members", optionalBody: true)
  Future<Response> getGroupMembers(
    @Path("roomId") String roomId,
    @QueryMap() Map<String, dynamic> query,
  );

  ///get getGroupMembers
  @Post(path: "/{roomId}/group/members")
  Future<Response> addParticipantsToGroup(
    @Path("roomId") String roomId,
    @Body() Map<String, dynamic> body,
  );

  @Patch(
    path: "/{roomId}/group/members/{identifier}/{role}",
    optionalBody: true,
  )
  Future<Response> changeUserGroupRole(
    @Path('roomId') String roomId,
    @Path('identifier') String peerIdentifier,
    @Path('role') String role,
  );

  @Delete(path: "/{roomId}/group/members/{identifier}", optionalBody: true)
  Future<Response> kickGroupUser(
    @Path('roomId') String roomId,
    @Path('identifier') String peerIdentifier,
  );

  static ChannelApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: VAppConstants.baseUri,
      services: [
        _$ChannelApi(),
      ],
      converter: const JsonConverter(),
      interceptors: [AuthInterceptor()],
      errorConverter: ErrorInterceptor(),
      client: VPlatforms.isWeb
          ? null
          : IOClient(
              HttpClient()..connectionTimeout = const Duration(seconds: 8),
            ),
    );
    return _$ChannelApi(client);
  }
}
