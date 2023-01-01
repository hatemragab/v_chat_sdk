import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' hide Response, Request;
import 'package:http/io_client.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../utils/api_constants.dart';
import '../interceptors.dart';

part 'channel_api.chopper.dart';

@ChopperApi(baseUrl: 'channel')
abstract class ChannelApi extends ChopperService {
  @Post(path: "/peer-room/{identifier}")
  Future<Response> getPeerRoom(@Path() String identifier);

  @Get(path: "/{roomId}/single/my-info")
  Future<Response> getMySingleRoomInfo(
    @Path("roomId") String roomId,
  );

  @Get(path: "/{roomId}")
  Future<Response> getRoomById(@Path() String roomId);

  @Patch(path: "/{roomId}/notification", optionalBody: true)
  Future<Response> changeRoomNotification(
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

  @Post(path: "/broadcast")
  @multipart
  Future<Response> createBroadcast(
      @PartMap() List<PartValue> body, @PartFile("file") MultipartFile? file);

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
    @Path('peerId') String peerId,
  );

  @Get(path: "/{roomId}/broadcast/my-info")
  Future<Response> getMyBroadcastInfo(
    @Path("roomId") String roomId,
  );

  /// group apis
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

  @Patch(path: "/{roomId}/group/members/{peerId}/{role}", optionalBody: true)
  Future<Response> changeUserGroupRole(
    @Path('roomId') String roomId,
    @Path('peerId') String peerId,
    @Path('role') String role,
  );

  @Delete(path: "/{roomId}/group/members/{peerId}", optionalBody: true)
  Future<Response> kickGroupUser(
    @Path('roomId') String roomId,
    @Path('peerId') String peerId,
  );

  static ChannelApi create({
    String? baseUrl,
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
