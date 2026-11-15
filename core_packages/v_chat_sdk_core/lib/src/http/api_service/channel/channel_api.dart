// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' hide Request, Response;
import 'package:http/io_client.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_platform/v_platform.dart';

part 'channel_api.chopper.dart';

@ChopperApi(baseUrl: 'channel')
abstract class ChannelApi extends ChopperService {
  /// ----------------------------------------- single chat apis ------------------------------------------

  @POST(path: "/peer-room/{identifier}", optionalBody: true)
  Future<Response> getPeerRoom(@Path() String identifier);

  @GET(path: "/messages/stars")
  Future<Response> getAllStarMessages();

  @PATCH(path: "/{roomId}/nick-name")
  Future<Response> updateRoomNickName(
    @Path() String roomId,
    @Body() Map<String, dynamic> body,
  );

  @GET(path: "/{roomId}")
  Future<Response> getRoomById(@Path() String roomId);

  @PATCH(path: "/{roomId}/notification/mute", optionalBody: true)
  Future<Response> muteRoomNotification(@Path() String roomId);

  @PATCH(path: "/{roomId}/notification/un-mute", optionalBody: true)
  Future<Response> unMuteRoomNotification(@Path() String roomId);

  @PATCH(path: "/{roomId}/one-seen/off", optionalBody: true)
  Future<Response> oneSeenOff(@Path() String roomId);

  @PATCH(path: "/{roomId}/one-seen/on", optionalBody: true)
  Future<Response> oneSeenOn(@Path() String roomId);

  @PATCH(path: "/{roomId}/archive", optionalBody: true)
  Future<Response> archiveRoom(@Path() String roomId);

  @PATCH(path: "/{roomId}/un-archive", optionalBody: true)
  Future<Response> unArchiveRoom(@Path() String roomId);

  @GET(path: "/{roomId}/un-read-count")
  Future<Response> getRoomUnReadCount(@Path() String roomId);

  @GET(path: "/{roomId}/url-preview")
  Future<Response> getUrlPreview(
    @Path() String roomId,
    @QueryMap() Map<String, dynamic> query,
  );

  ///deliver room messages
  @PATCH(path: "/{roomId}/translate", optionalBody: true)
  Future<Response> transTo(
    @Path() String roomId,
    @Body() Map<String, dynamic> body,
  );

  /// translate/stop
  @PATCH(path: "/{roomId}/translate/stop", optionalBody: true)
  Future<Response> stopRoomAutoTranslate(@Path() String roomId);

  ///delete room
  @DELETE(path: "/{roomId}")
  Future<Response> deleteRoom(@Path() String roomId);

  @GET(path: "/")
  Future<Response> getRooms(@QueryMap() Map<String, dynamic> query);

  @PATCH(path: "/{roomId}/deliver", optionalBody: true)
  Future<Response> deliverRoomMessages(@Path() String roomId);

  /// ----------------------------------------- broadcast apis ------------------------------------------
  @POST(path: "/broadcast")
  @multipart
  Future<Response> createBroadcast(
    @PartMap() List<PartValue> body,
    @PartFile("file") MultipartFile? file,
  );

  @PATCH(path: "/{roomId}/broadcast/title")
  Future<Response> updateBroadcastTitle(
    @Path("roomId") String roomId,
    @Body() Map<String, dynamic> body,
  );

  @PATCH(path: "/{roomId}/broadcast/image")
  @multipart
  Future<Response> updateBroadcastImage(
    @Path('roomId') String roomId,
    @PartFile("file") MultipartFile file,
  );

  @GET(path: "/{roomId}/broadcast/members")
  Future<Response> getBroadcastMembers(
    @Path("roomId") String roomId,
    @QueryMap() Map<String, dynamic> query,
  );
  @GET(path: "/{roomId}/broadcast/available-users-to-add")
  Future<Response> getAvailableBroadcastMembersToAdded(
    @Path("roomId") String roomId,
    @QueryMap() Map<String, dynamic> query,
  );

  @POST(path: "/{roomId}/broadcast/members")
  Future<Response> addParticipantsToBroadcast(
    @Path("roomId") String roomId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(path: "/{roomId}/broadcast/members/{peerId}")
  Future<Response> kickBroadcastUser(
    @Path('roomId') String roomId,
    @Path('identifier') String identifier,
  );

  @GET(path: "/{roomId}/broadcast/my-info")
  Future<Response> getMyBroadcastInfo(@Path("roomId") String roomId);

  @GET(path: "/{roomId}/broadcast/message/{messageId}/status/{type}")
  Future<Response> getMessageStatusForBroadcast(
    @Path("roomId") String roomId,
    @Path("messageId") String mId,

    ///it can be seen or deliver
    @QueryMap() Map<String, dynamic> query,
    @Path("type") String type,
  );

  /// ----------------------------------------- group apis ------------------------------------------
  @POST(path: "/group")
  @multipart
  Future<Response> createGroup(
    @PartMap() List<PartValue> body,
    @PartFile("file") MultipartFile? file,
  );

  @POST(path: "/{roomId}/group/leave", optionalBody: true)
  Future<Response> leaveGroup(@Path("roomId") String roomId);

  ///updateRoomTitle
  @PATCH(path: "/{roomId}/group/title")
  Future<Response> updateGroupTitle(
    @Path("roomId") String roomId,
    @Body() Map<String, dynamic> body,
  );

  @PATCH(path: "/{roomId}/group/description")
  Future<Response> updateGroupDescription(
    @Path("roomId") String roomId,
    @Body() Map<String, dynamic> body,
  );

  @GET(path: "/{roomId}/group/available-users-to-add")
  Future<Response> getAvailableGroupMembersToAdded(
    @Path("roomId") String roomId,
    @QueryMap() Map<String, dynamic> query,
  );

  @GET(path: "/{roomId}/group/message/{messageId}/status/{type}")
  Future<Response> getMessageStatusForGroup(
    @Path("roomId") String roomId,
    @Path("messageId") String mId,

    ///it can be seen or deliver
    @QueryMap() Map<String, dynamic> query,
    @Path("type") String type,
  );

  ///updateRoomExtra data
  @PATCH(path: "/{roomId}/group/extra-data")
  Future<Response> updateGroupExtraData(
    @Path("roomId") String roomId,
    @Body() Map<String, dynamic> body,
  );

  ///updateRoomImage
  @PATCH(path: "/{roomId}/group/image")
  @multipart
  Future<Response> updateGroupImage(
    @Path('roomId') String roomId,
    @PartFile("file") MultipartFile file,
  );

  @GET(path: "/{roomId}/group/my-info")
  Future<Response> getMyGroupInfo(@Path("roomId") String roomId);

  @GET(path: "/{roomId}/group/my-status")
  Future<Response> getMyGroupStatus(@Path("roomId") String roomId);

  ///get getGroupMembers
  @GET(path: "/{roomId}/group/members")
  Future<Response> getGroupMembers(
    @Path("roomId") String roomId,
    @QueryMap() Map<String, dynamic> query,
  );

  ///get getGroupMembers
  @POST(path: "/{roomId}/group/members")
  Future<Response> addParticipantsToGroup(
    @Path("roomId") String roomId,
    @Body() Map<String, dynamic> body,
  );

  @PATCH(
    path: "/{roomId}/group/members/{identifier}/{role}",
    optionalBody: true,
  )
  Future<Response> changeUserGroupRole(
    @Path('roomId') String roomId,
    @Path('identifier') String peerIdentifier,
    @Path('role') String role,
  );

  @DELETE(path: "/{roomId}/group/members/{identifier}")
  Future<Response> kickGroupUser(
    @Path('roomId') String roomId,
    @Path('identifier') String peerIdentifier,
  );

  /// ----------------------------------------- order apis ------------------------------------------

  @GET(path: "/{roomId}/group/members")
  Future<Response> getOrderRoomInfo(@Path("roomId") String roomId);

  static ChannelApi create({Uri? baseUrl, String? accessToken}) {
    final client = ChopperClient(
      baseUrl: VAppConstants.baseUri,
      services: [_$ChannelApi()],
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
