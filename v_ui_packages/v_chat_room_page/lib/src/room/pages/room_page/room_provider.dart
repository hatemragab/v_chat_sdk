// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../assets/data/api_rooms.dart';
import '../../../assets/data/local_rooms.dart';

class RoomProvider {
  final _localRoom = VChatController.I.nativeApi.local.room;
  final _remoteRoom = VChatController.I.nativeApi.remote.room;

  Future<List<VRoom>> getFakeLocalRooms() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return [VRoom.fromLocalMap(fakeLocalRooms.first)];
  }

  Future<VPaginationModel<VRoom>> getLocalRooms() async {
    return VPaginationModel<VRoom>(
      values: await _localRoom.getRooms(limit: 200),
      page: 1,
      limit: 200,
    );
  }

  Future<List<VRoom>> getFakeApiRooms() async {
    await Future.delayed(const Duration(milliseconds: 1100));
    return [VRoom.fromMap(fakeApiRooms.first)];
  }

  Future<VPaginationModel<VRoom>> getApiRooms(
    VRoomsDto dto, {
    bool deleteOnEmpty = true,
  }) async {
    final apiModel = await _remoteRoom.getRooms(dto);
    unawaited(_localRoom.cacheRooms(
      apiModel.values,
      deleteOnEmpty: deleteOnEmpty,
    ));
    return apiModel;
  }

  Future<VRoom?> getLocalRoomById(String roomId) async {
    return _localRoom.getOneWithLastMessageByRoomId(roomId);
  }

  Future<bool> mute(String roomId) async {
    await _remoteRoom.changeRoomNotification(
      roomId: roomId,
      isMuted: true,
    );
    await _localRoom.updateRoomIsMuted(VUpdateRoomMuteEvent(
      roomId: roomId,
      isMuted: true,
    ));
    return true;
  }

  Future<bool> unMute(String roomId) async {
    await _remoteRoom.changeRoomNotification(
      roomId: roomId,
      isMuted: false,
    );
    await _localRoom.updateRoomIsMuted(VUpdateRoomMuteEvent(
      roomId: roomId,
      isMuted: false,
    ));
    return true;
  }

  Future<bool> deleteRoom(String roomId) async {
    await _remoteRoom.deleteRoom(roomId);
    await _localRoom.deleteRoom(roomId);
    return true;
  }

  // Future<bool> block(String roomId) async {
  //   await _remoteRoom.closeChat(roomId);
  //   return true;
  // }
  //
  // Future<bool> unBlock(String roomId) async {
  //   await _remoteRoom.closeChat(roomId);
  //   return true;
  // }

  Future groupLeave(String roomId) async {
    return await _remoteRoom.leaveGroup(roomId);
  }
}
