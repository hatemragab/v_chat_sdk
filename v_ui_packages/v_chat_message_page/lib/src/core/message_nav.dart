// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_message_page/src/page/message_status/group/message_group_status_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../v_chat_message_page.dart';
import '../page/chat_media/chat_media_page.dart';
import '../page/message_status/broadcast/message_broadcast_status_page.dart';
import '../page/message_status/single/message_single_status_page.dart';

final vDefaultMessageNavigator = VMessageNavigator(
  toViewChatMedia: (context, roomId) => context.toPage(ChatMediaPage(
    roomId: roomId,
  )),
  toMessagePage: (context, vRoom) {
    if (vRoom.roomType.isSingle) {
      return context.toPage(
        VSingleView(vRoom: vRoom),
      );
    } else if (vRoom.roomType.isGroup) {
      return context.toPage(
        VGroupView(vRoom: vRoom),
      );
    } else if (vRoom.roomType.isBroadcast) {
      return context.toPage(
        VBroadcastView(vRoom: vRoom),
      );
    } else if (vRoom.roomType.isOrder) {
      return context.toPage(
        VOrderView(vRoom: vRoom),
      );
    }
  },
  toVideoPlayer: (context, source) {
    return context.toPage(
      VVideoPlayer(
        platformFileSource: source,
        appName: VAppConstants.appName,
      ),
    );
  },
  toImageViewer: (context, source) {
    return context.toPage(
      VImageViewer(
        platformFileSource: source,
        appName: VAppConstants.appName,
      ),
    );
  },
  toGroupChatMessageInfo: (context, message) =>
      context.toPage(VMessageGroupStatusPage(message: message)),
  toBroadcastChatMessageInfo: (context, message) =>
      context.toPage(VMessageBroadcastStatusPage(
    message: message,
  )),
  toSingleChatMessageInfo: (context, message) =>
      context.toPage(VMessageSingleStatusPage(
    message: message,
  )),
);
