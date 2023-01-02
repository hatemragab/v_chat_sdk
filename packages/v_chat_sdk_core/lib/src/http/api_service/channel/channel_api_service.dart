import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/src/http/dto/create_group_dto.dart';
import 'package:v_chat_sdk_core/src/models/models.dart';
import 'package:v_chat_sdk_core/src/utils/enums.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../v_chat_sdk_core.dart';
import '../../../models/v_room/single_room/single_ban_model.dart';
import '../../../utils/api_constants.dart';
import '../../dto/create_broadcast_dto.dart';
import 'channel_api.dart';

class ChannelApiService {
  static late final ChannelApi _channelApiService;

  ChannelApiService._();

  Future<VRoom> getPeerRoom(String peerId) async {
    final res = await _channelApiService.getPeerRoom(peerId);
    throwIfNotSuccess(res);
    return VRoom.fromMap(extractDataFromResponse(res));
  }

  Future<VRoom> getRoomById(String roomId) async {
    final res = await _channelApiService.getRoomById(roomId);
    throwIfNotSuccess(res);
    return VRoom.fromMap(extractDataFromResponse(res));
  }

  Future<bool> changeRoomNotification(
    String roomId,
  ) async {
    final res = await _channelApiService.changeRoomNotification(roomId);
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> deleteRoom(
    String roomId,
  ) async {
    final res = await _channelApiService.deleteRoom(roomId);
    throwIfNotSuccess(res);
    return true;
  }

  Future<VPaginationModel<VRoom>> getRooms(VRoomsDto dto) async {
    final res = await _channelApiService.getRooms(dto.toMap());
    throwIfNotSuccess(res);
    final data = extractDataFromResponse(res);
    return VPaginationModel<VRoom>.fromCustomMap(
      values: (data['docs'] as List).map((e) => VRoom.fromMap(e)).toList(),
      map: data,
    );
  }

  Future<bool> deliverRoomMessages(
    String roomId,
  ) async {
    final res = await _channelApiService.deliverRoomMessages(roomId);
    throwIfNotSuccess(res);
    return true;
  }

  Future<VRoom> createBroadcast(
    CreateBroadcastDto dto,
  ) async {
    final res = await _channelApiService.createBroadcast(
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
    final res = await _channelApiService.getMyBroadcastInfo(roomId);
    throwIfNotSuccess(res);
    return VMyBroadcastInfo.fromMap(extractDataFromResponse(res));
  }

  Future<bool> updateBroadcastTitle(
    String roomId,
    String title,
  ) async {
    final res = await _channelApiService.updateBroadcastTitle(roomId, {
      "title": title,
    });
    throwIfNotSuccess(res);
    return true;
  }

  Future<String> updateBroadcastImage(
    String roomId,
    VPlatformFileSource file,
  ) async {
    final res = await _channelApiService.updateBroadcastImage(
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
    final res = await _channelApiService.addParticipantsToBroadcast(
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
    final res = await _channelApiService.kickBroadcastUser(
      roomId,
      peerId,
    );
    throwIfNotSuccess(res);
    return true;
  }

  Future<VRoom> createGroup(
    CreateGroupDto dto,
  ) async {
    final res = await _channelApiService.createGroup(
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
    final res = await _channelApiService.getMyGroupStatus(roomId);
    throwIfNotSuccess(res);
    return extractDataFromResponse(res)['isMeOut'] as bool;
  }

  Future<bool> leaveGroup(String roomId) async {
    final res = await _channelApiService.leaveGroup(roomId);
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> updateGroupTitle(
    String roomId,
    String title,
  ) async {
    final res = await _channelApiService.updateGroupTitle(roomId, {
      "title": title,
    });
    throwIfNotSuccess(res);
    return true;
  }

  Future<String> updateGroupImage(
    String roomId,
    VPlatformFileSource file,
  ) async {
    final res = await _channelApiService.updateGroupImage(
      roomId,
      await VPlatforms.getMultipartFile(
        source: file,
      ),
    );
    throwIfNotSuccess(res);
    return (res.body as Map<String, dynamic>)['data'] as String;
  }

  Future<VSingleBanModel> getMySingleRoomInfo(
    String roomId,
  ) async {
    final res = await _channelApiService.getMySingleRoomInfo(
      roomId,
    );
    throwIfNotSuccess(res);
    return VSingleBanModel.fromMap(
      extractDataFromResponse(res),
    );
  }

  // Future<List<GroupMember>> getGroupMembers(
  //     String roomId,
  //     Map<String, dynamic> filter,
  //     ) async {
  //   final res = await _channelApiService.getGroupMembers(roomId, filter);
  //   if (!res.isSuccessful)
  //     throw BadRequestHttpException(
  //       error: HttpError.fromChopper(res),
  //     );
  //   return ((res.body as Map<String, dynamic>)['data'] as List)
  //       .map((e) => GroupMember.fromMap(e as Map<String, dynamic>))
  //       .toList();
  // }
  Future<bool> addParticipantsToGroup(
    String roomId,
    List<String> ids,
  ) async {
    final res =
        await _channelApiService.addParticipantsToGroup(roomId, {"ids": ids});
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> changeUserGroupRole(
    String roomId,
    String peerId,
    GroupMemberRole role,
  ) async {
    final res = await _channelApiService.changeUserGroupRole(
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
    final res = await _channelApiService.kickGroupUser(
      roomId,
      peerId,
    );
    throwIfNotSuccess(res);
    return true;
  }

  static ChannelApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _channelApiService = ChannelApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? VAppConstants.baseUri,
    );
    return ChannelApiService._();
  }
}
