// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

abstract class BaseLocalRoomRepo {
  Future<int> insert(VInsertRoomEvent event);

  Future<int> updateName(VUpdateRoomNameEvent event);

  Future<int> updateTransTo(VUpdateTransToEvent event);

  Future<int> insertMany(List<VRoom> rooms);

  Future<int> updateImage(VUpdateRoomImageEvent event);

  Future<int> updateCountByOne(VUpdateRoomUnReadCountByOneEvent event);

  Future<int> updateCountToZero(VUpdateRoomUnReadCountToZeroEvent event);

  Future<int> updateIsMuted(VUpdateRoomMuteEvent event);

  Future<int> delete(VDeleteRoomEvent event);

  Future<void> reCreate();

  Future<VRoom?> getOneByPeerId(String roomId);

  Future<String?> getRoomIdByPeerId(String peerId);
  Future<bool> isRoomExist(String roomId);

  Future<VRoom?> getOneWithLastMessageByRoomId(String roomId);

  Future<List<VRoom>> search(String text, int limit, VRoomType? roomType);

  Future<List<VRoom>> getRoomsWithLastMessage({int limit = 300});
}
