// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:v_chat_message_page/src/page/message_pages/controllers/v_base_message_controller.dart';
import 'package:v_chat_message_page/src/page/message_pages/states/last_seen_state_controller.dart';
import 'package:v_chat_message_page/src/page/message_pages/states/my_info_broadcast_state_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../controllers/message_stream_state_controller.dart';

class VBroadcastController extends VBaseMessageController {
  LastSeenStateController? lastSeenStateController;
  late final MessageStreamState _localStreamChanges;

  VBroadcastController({
    required super.vRoom,
    required super.context,
    required super.messageProvider,
    required super.scrollController,
    required super.appBarStateController,
    required super.inputStateController,
    required super.itemController,
  }) {
    _initStates();
  }

  @override
  void close() {
    _localStreamChanges.close();
    lastSeenStateController?.close();
    super.close();
  }

  @override
  void onTitlePress(BuildContext context, String id, VRoomType roomType) {
    final toBroadcastSettings =
        VChatController.I.vNavigator.messageNavigator.toBroadcastSettings;
    if (toBroadcastSettings == null) return;
    toBroadcastSettings(
      context,
      VToChatSettingsModel(
        title: vRoom.title,
        image: vRoom.thumbImage,
        roomId: roomId,
        room: vRoom,
      ),
    );
  }

  void _initStates() {
    MyInfoBroadcastStateController(vRoom, appBarStateController);
    _localStreamChanges = MessageStreamState(
      nativeApi: VChatController.I.nativeApi,
      messageState: this,
      appBarStateController: appBarStateController,
      inputStateController: inputStateController,
      currentRoom: vRoom,
    );
  }

  @override
  Future<List<VMentionModel>> onMentionRequireSearch(
      BuildContext context, String query) async {
    return <VMentionModel>[];
  }
}
