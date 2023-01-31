import 'package:v_chat_sdk_core/src/http/api_service/channel/channel_api.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VChannelApiService {
  static ChannelApi? _channelApiService;

  VChannelApiService._();

  Future<VRoom> getPeerRoom(String peerId) async {
    final res = await _channelApiService!.getPeerRoom(peerId);
    throwIfNotSuccess(res);
    return VRoom.fromMap(extractDataFromResponse(res));
  }

  Future<VRoom> getRoomById(String roomId) async {
    final res = await _channelApiService!.getRoomById(roomId);
    throwIfNotSuccess(res);
    return VRoom.fromMap(extractDataFromResponse(res));
  }

  Future<void> closeChat(String roomId) async {
    final res = await _channelApiService!.closeChat(roomId);
    throwIfNotSuccess(res);
  }

  Future<bool> changeRoomNotification(
    String roomId,
  ) async {
    final res = await _channelApiService!.changeRoomNotification(roomId);
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> deleteRoom(
    String roomId,
  ) async {
    final res = await _channelApiService!.deleteRoom(roomId);
    throwIfNotSuccess(res);
    return true;
  }

  Future<VPaginationModel<VRoom>> getRooms(VRoomsDto dto) async {
    final res = await _channelApiService!.getRooms(dto.toMap());
    throwIfNotSuccess(res);
    final data = extractDataFromResponse(res);
    return VPaginationModel<VRoom>.fromCustomMap(
      values: (data['docs'] as List)
          .map((e) => VRoom.fromMap(e as Map<String, dynamic>))
          .toList(),
      map: data,
    );
  }

  Future<bool> deliverRoomMessages(
    String roomId,
  ) async {
    final res = await _channelApiService!.deliverRoomMessages(roomId);
    throwIfNotSuccess(res);
    return true;
  }

  Future<VRoom> createBroadcast(
    CreateBroadcastDto dto,
  ) async {
    final res = await _channelApiService!.createBroadcast(
      dto.toListOfPartValue(),
      dto.platformImage == null
          ? null
          : await VPlatforms.getMultipartFile(
              source: dto.platformImage!,
            ),
    );
    throwIfNotSuccess(res);
    return VRoom.fromMap(
      extractDataFromResponse(res),
    );
  }

  Future<VMyBroadcastInfo> getBroadcastInfo(String roomId) async {
    final res = await _channelApiService!.getMyBroadcastInfo(roomId);
    throwIfNotSuccess(res);
    return VMyBroadcastInfo.fromMap(extractDataFromResponse(res));
  }

  Future<bool> updateBroadcastTitle(
    String roomId,
    String title,
  ) async {
    final res = await _channelApiService!.updateBroadcastTitle(roomId, {
      "title": title,
    });
    throwIfNotSuccess(res);
    return true;
  }

  Future<String> updateBroadcastImage(
    String roomId,
    VPlatformFileSource file,
  ) async {
    final res = await _channelApiService!.updateBroadcastImage(
      roomId,
      await VPlatforms.getMultipartFile(
        source: file,
      ),
    );
    throwIfNotSuccess(res);
    return (res.body as Map<String, dynamic>)['data'] as String;
  }

  // Future<List<BroadcastMember>> getBroadcastMembers(
  //   String roomId,
  //   Map<String, dynamic> filter,
  // ) async {
  //   final res = await _channelApiService.getBroadcastMembers(roomId, filter);
  //   throwIfNotSuccess(res);
  //   return ((res.body as Map<String, dynamic>)['data'] as List)
  //       .map((e) => BroadcastMember.fromMap(e as Map<String, dynamic>))
  //       .toList();
  // }
  Future<bool> addParticipantsToBroadcast(
    String roomId,
    List<String> body,
  ) async {
    final res = await _channelApiService!.addParticipantsToBroadcast(
      roomId,
      {"ids": body},
    );
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> kickBroadcastUser(
    String roomId,
    String peerId,
  ) async {
    final res = await _channelApiService!.kickBroadcastUser(
      roomId,
      peerId,
    );
    throwIfNotSuccess(res);
    return true;
  }

  Future<VRoom> createGroup(
    CreateGroupDto dto,
  ) async {
    final res = await _channelApiService!.createGroup(
      dto.toListOfPartValue(),
      dto.platformImage == null
          ? null
          : await VPlatforms.getMultipartFile(
              source: dto.platformImage!,
            ),
    );
    throwIfNotSuccess(res);
    return VRoom.fromMap(extractDataFromResponse(res));
  }

  // Future<GroupInfo> getGroupInfo(String roomId) async {
  //   final res = await _channelApiService.getMyGroupInfo(roomId);
  //   throwIfNotSuccess(res);
  //   return GroupInfo.fromMap(extractDataFromResponse(res));
  // }

  Future<bool> getGroupStatus(String roomId) async {
    final res = await _channelApiService!.getMyGroupStatus(roomId);
    throwIfNotSuccess(res);
    return extractDataFromResponse(res)['isMeOut'] as bool;
  }

  Future<VMyGroupInfo> getMyGroupInfo(String roomId) async {
    final res = await _channelApiService!.getMyGroupInfo(roomId);
    throwIfNotSuccess(res);
    return VMyGroupInfo.fromMap(extractDataFromResponse(res));
  }

  Future<List<VMentionModel>> searchToMention(
    String roomId, {
   required VBaseFilter filter,
  }) async {
    final res = await _channelApiService!
        .getGroupMembers(roomId,  filter.toMap());
    throwIfNotSuccess(res);
    final list = extractDataFromResponse(res)['docs'] as List;
    final users = list
        .map((e) => VIdentifierUser.fromMap(
              (e as Map<String, dynamic>)['userData'] as Map<String, dynamic>,
            ))
        .toList();
    return users
        .map((e) => VMentionModel(
              identifier: e.identifier,
              name: e.baseUser.fullName,
              image: e.baseUser.userImages.smallImage,
            ))
        .toList();
  }

  Future<bool> leaveGroup(String roomId) async {
    final res = await _channelApiService!.leaveGroup(roomId);
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> updateGroupTitle(
    String roomId,
    String title,
  ) async {
    final res = await _channelApiService!.updateGroupTitle(roomId, {
      "title": title,
    });
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> updateGroupExtraData(
    String roomId,
    Map<String, dynamic> data,
  ) async {
    final res = await _channelApiService!.updateGroupExtraData(roomId, data);
    throwIfNotSuccess(res);
    return true;
  }

  Future<List<VMessageStatusModel>> getMessageStatusForGroup(
    String roomId,
    String messageId,
    Map<String, Object> pagination, {
    required bool isSeen,
  }) async {
    final res = await _channelApiService!.getMessageStatusForGroup(
      roomId,
      messageId,
      pagination,
      isSeen ? "seen" : "deliver",
    );

    throwIfNotSuccess(res);
    final resList = extractDataFromResponse(res)['docs'] as List;
    return resList
        .map((e) => VMessageStatusModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<String> updateGroupImage(
    String roomId,
    VPlatformFileSource file,
  ) async {
    final res = await _channelApiService!.updateGroupImage(
      roomId,
      await VPlatforms.getMultipartFile(
        source: file,
      ),
    );
    throwIfNotSuccess(res);
    return (res.body as Map<String, dynamic>)['data'] as String;
  }

  // Future<VSingleBanModel> getMySingleRoomInfo(
  //   String roomId,
  // ) async {
  //   final res = await _channelApiService.getMySingleRoomInfo(
  //     roomId,
  //   );
  //   throwIfNotSuccess(res);
  //   return VSingleBanModel.fromMap(
  //     extractDataFromResponse(res),
  //   );
  // }

  Future<List<VGroupMember>> getGroupMembers(
    String roomId, {
    VBaseFilter? filter,
  }) async {
    final res = await _channelApiService!.getGroupMembers(
      roomId,
      filter == null ? {} : filter.toMap(),
    );
    final data = extractDataFromResponse(res)['docs'] as List;
    return data
        .map((e) => VGroupMember.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<bool> addParticipantsToGroup(
    String roomId,
    List<String> ids,
  ) async {
    final res = await _channelApiService!
        .addParticipantsToGroup(roomId, {"identifiers": ids});
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> changeUserGroupRole(
    String roomId,
    String peerId,
    VGroupMemberRole role,
  ) async {
    final res = await _channelApiService!.changeUserGroupRole(
      roomId,
      peerId,
      role.name,
    );
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> kickGroupUser(
    String roomId,
    String peerId,
  ) async {
    final res = await _channelApiService!.kickGroupUser(
      roomId,
      peerId,
    );
    throwIfNotSuccess(res);
    return true;
  }

  static VChannelApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _channelApiService ??= ChannelApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? VAppConstants.baseUri,
    );
    return VChannelApiService._();
  }
}
