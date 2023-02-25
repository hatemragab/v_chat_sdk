// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

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

  // Future<void> closeChat(String roomId) async {
  //   final res = await _channelApiService!.closeChat(roomId);
  //   throwIfNotSuccess(res);
  // }

  Future<bool> changeRoomNotification({
    required String roomId,
    required bool isMuted,
  }) async {
    final res = await _channelApiService!
        .changeRoomNotification(roomId, {"isMuted": isMuted});
    throwIfNotSuccess(res);
    return (res.body as Map<String, dynamic>)['data'] as bool;
  }

  Future<bool> transTo({
    required String roomId,
    required String transTo,
  }) async {
    final res = await _channelApiService!.transTo(roomId, {"transTo": transTo});
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> stopRoomAutoTranslate({
    required String roomId,
  }) async {
    final res = await _channelApiService!.stopRoomAutoTranslate(roomId);
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

  Future<bool> updateBroadcastTitle({
    required String roomId,
    required String title,
  }) async {
    final res = await _channelApiService!.updateBroadcastTitle(roomId, {
      "title": title,
    });
    throwIfNotSuccess(res);
    return true;
  }

  Future<String> updateBroadcastImage({
    required String roomId,
    required VPlatformFileSource file,
  }) async {
    final res = await _channelApiService!.updateBroadcastImage(
      roomId,
      await VPlatforms.getMultipartFile(
        source: file,
      ),
    );
    throwIfNotSuccess(res);
    return (res.body as Map<String, dynamic>)['data'] as String;
  }

  Future<List<VBroadcastMember>> getBroadcastMembers({
    required String roomId,
    VBaseFilter? filter,
  }) async {
    final res = await _channelApiService!.getBroadcastMembers(
      roomId,
      filter == null ? {} : filter.toMap(),
    );
    throwIfNotSuccess(res);
    return (extractDataFromResponse(res)['docs'] as List)
        .map((e) => VBroadcastMember.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<bool> addParticipantsToBroadcast({
    required String roomId,
    required List<String> identifiers,
  }) async {
    final res = await _channelApiService!.addParticipantsToBroadcast(
      roomId,
      {"identifiers": identifiers},
    );
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> kickBroadcastUser({
    required String roomId,
    required String peerIdentifier,
  }) async {
    final res = await _channelApiService!.kickBroadcastUser(
      roomId,
      peerIdentifier,
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
    final res =
        await _channelApiService!.getGroupMembers(roomId, filter.toMap());
    throwIfNotSuccess(res);
    final list = extractDataFromResponse(res)['docs'] as List;
    final users = list
        .map(
          (e) => VIdentifierUser.fromMap(
            (e as Map<String, dynamic>)['userData'] as Map<String, dynamic>,
          ),
        )
        .toList();
    return users
        .map(
          (e) => VMentionModel(
            identifier: e.identifier,
            name: e.baseUser.fullName,
            image: e.baseUser.userImages.smallImage,
          ),
        )
        .toList();
  }

  Future<bool> leaveGroup(String roomId) async {
    final res = await _channelApiService!.leaveGroup(roomId);
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> updateGroupTitle({
    required String roomId,
    required String title,
  }) async {
    final res = await _channelApiService!.updateGroupTitle(roomId, {
      "title": title,
    });
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> updateGroupDescription({
    required String roomId,
    required String description,
  }) async {
    final res = await _channelApiService!.updateGroupDescription(roomId, {
      "description": description,
    });
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> updateGroupExtraData({
    required String roomId,
    required Map<String, dynamic> data,
  }) async {
    final res = await _channelApiService!.updateGroupExtraData(roomId, data);
    throwIfNotSuccess(res);
    return true;
  }

  Future<List<VMessageStatusModel>> getMessageStatusForGroup({
    required String roomId,
    required String messageId,
    VBaseFilter? pagination,
    required bool isSeen,
  }) async {
    final res = await _channelApiService!.getMessageStatusForGroup(
      roomId,
      messageId,
      pagination == null ? {} : pagination.toMap(),
      isSeen ? "seen" : "deliver",
    );

    throwIfNotSuccess(res);
    final resList = extractDataFromResponse(res)['docs'] as List;
    return resList
        .map((e) => VMessageStatusModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<VMessageStatusModel>> getMessageStatusForBroadcast({
    required String roomId,
    required String messageId,
    VBaseFilter? pagination,
    required bool isSeen,
  }) async {
    final res = await _channelApiService!.getMessageStatusForBroadcast(
      roomId,
      messageId,
      pagination == null ? {} : pagination.toMap(),
      isSeen ? "seen" : "deliver",
    );

    throwIfNotSuccess(res);
    final resList = extractDataFromResponse(res)['docs'] as List;
    return resList
        .map((e) => VMessageStatusModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<String> updateGroupImage({
    required String roomId,
    required VPlatformFileSource file,
  }) async {
    final res = await _channelApiService!.updateGroupImage(
      roomId,
      await VPlatforms.getMultipartFile(
        source: file,
      ),
    );
    throwIfNotSuccess(res);
    return (res.body as Map<String, dynamic>)['data'] as String;
  }

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

  Future<bool> addParticipantsToGroup({
    required String roomId,
    required List<String> ids,
  }) async {
    final res = await _channelApiService!
        .addParticipantsToGroup(roomId, {"identifiers": ids});
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> changeUserGroupRole({
    required String roomId,
    required String peerIdentifier,
    required VGroupMemberRole role,
  }) async {
    final res = await _channelApiService!.changeUserGroupRole(
      roomId,
      peerIdentifier,
      role.name,
    );
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> kickGroupUser({
    required String roomId,
    required String peerIdentifier,
  }) async {
    final res = await _channelApiService!.kickGroupUser(
      roomId,
      peerIdentifier,
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
