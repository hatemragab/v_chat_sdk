// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_room_page/src/room/shared/extension.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../v_chat_room_page.dart';

final vDefaultRoomNavigator = VRoomNavigator(
  toForwardPage: (context, currentRoomId) async {
    return await context.toPage(VChooseRoomsPage(
      currentRoomId: currentRoomId,
    ));
  },
);
