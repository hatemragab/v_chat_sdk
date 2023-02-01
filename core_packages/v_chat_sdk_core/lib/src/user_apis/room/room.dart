import 'package:v_chat_sdk_core/src/http/api_service/channel/channel_api_service.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class RoomApi {
  final VNativeApi _vNativeApi;

  VChannelApiService get _channelApiService => _vNativeApi.remote.room;

  RoomApi(
    this._vNativeApi,
  );

  Future<VRoom> getPeerRoom({
    required String peerIdentifier,
  }) async {
    return _channelApiService.getPeerRoom(peerIdentifier);
  }

  Future openChatWith({
    required String peerIdentifier,
  }) async {
    final buildContext = VChatController.I.navigatorKey.currentContext!;
    final localRoom =
        await _vNativeApi.local.room.getRoomByPeerId(peerIdentifier);
    if (localRoom != null) {
      VChatController.I.vNavigator.messageNavigator
          .toMessagePage(buildContext, localRoom);
    } else {
      final apiRoom = await _vNativeApi.remote.room.getPeerRoom(peerIdentifier);
      VChatController.I.vNavigator.messageNavigator
          .toMessagePage(buildContext, apiRoom);
    }
  }

  Future<bool> changeRoomNotification(String roomId) async {
    final res = await _vNativeApi.remote.room.changeRoomNotification(roomId);
    await _vNativeApi.local.room.updateRoomIsMuted(
      VUpdateRoomMuteEvent(
        roomId: roomId,
        isMuted: res,
      ),
    );
    return res;
  }

  Future<bool> changeGroupMemberRole({
    required String roomId,
    required String peerIdentifier,
    required VGroupMemberRole role,
  }) {
    return _vNativeApi.remote.room.changeUserGroupRole(
      peerIdentifier: peerIdentifier,
      role: role,
      roomId: roomId,
    );
  }

  Future<String> updateGroupImage({
    required String roomId,
    required VPlatformFileSource file,
  }) {
    return _vNativeApi.remote.room.updateGroupImage(roomId: roomId, file: file);
  }

  Future<bool> updateGroupDescription({
    required String roomId,
    required String description,
  }) {
    return _vNativeApi.remote.room.updateGroupDescription(
      roomId: roomId,
      description: description,
    );
  }

  Future<bool> updateGroupTitle({
    required String roomId,
    required String title,
  }) {
    return _vNativeApi.remote.room.updateGroupTitle(
      roomId: roomId,
      title: title,
    );
  }

  Future<VMyGroupInfo> getGroupVMyGroupInfo({
    required String roomId,
  }) {
    return _vNativeApi.remote.room.getMyGroupInfo(
      roomId,
    );
  }

  Future<bool> leaveGroup({
    required String roomId,
  }) async {
    await _vNativeApi.remote.room.leaveGroup(roomId);
    await _vNativeApi.local.room.deleteRoom(roomId);
    return true;
  }

  Future<VRoom> createGroup({
    required CreateGroupDto dto,
  }) {
    return _vNativeApi.remote.room.createGroup(
      dto,
    );
  }

  Future<bool> deleteRoom(
    String roomId,
  ) async {
    await _vNativeApi.local.room.deleteRoom(roomId);
    await _vNativeApi.remote.room.deleteRoom(roomId);
    return true;
  }

  Future<bool> addParticipantsToGroup(
    String roomId,
    List<String> ids,
  ) {
    return _vNativeApi.remote.room.addParticipantsToGroup(
      roomId: roomId,
      ids: ids,
    );
  }

  Future<List<VMessageStatusModel>> getMessageStatusForGroup({
    required String roomId,
    required String messageId,
    VBaseFilter? pagination,
    required bool isSeen,
  }) {
    return _vNativeApi.remote.room.getMessageStatusForGroup(
      roomId: roomId,
      isSeen: isSeen,
      messageId: messageId,
      pagination: pagination,
    );
  }

  Future<VRoom> createBroadcast({
    required CreateBroadcastDto dto,
  }) {
    return _vNativeApi.remote.room.createBroadcast(
      dto,
    );
  }

  Future<bool> updateGroupExtraData({
    required String roomId,
    required Map<String, dynamic> data,
  }) {
    return _vNativeApi.remote.room.updateGroupExtraData(
      roomId: roomId,
      data: data,
    );
  }

  Future<bool> kickGroupUser({
    required String roomId,
    required String peerIdentifier,
  }) {
    return _vNativeApi.remote.room.kickGroupUser(
      peerIdentifier: peerIdentifier,
      roomId: roomId,
    );
  }

  Future<List<VGroupMember>> getGroupMembers(
    String roomId, {
    VBaseFilter? filter,
  }) {
    return _vNativeApi.remote.room.getGroupMembers(
      roomId,
      filter: filter,
    );
  }
}
