// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:v_chat_message_page/src/page/message_pages/controllers/v_base_message_controller.dart';
import 'package:v_chat_message_page/src/page/message_pages/states/last_seen_state_controller.dart';
import 'package:v_chat_message_page/src/page/message_pages/states/my_info_group_state_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../controllers/message_stream_state_controller.dart';

class VGroupController extends VBaseMessageController {
  LastSeenStateController? lastSeenStateController;
  late final MessageStreamState _localStreamChanges;

  VGroupController({
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
    final toGroupSettings =
        VChatController.I.vNavigator.messageNavigator.toGroupSettings;
    if (toGroupSettings == null) return;
    toGroupSettings(
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
    MyInfoGroupStateController(
      inputStateController,
      vRoom,
      appBarStateController,
    );
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
    BuildContext context,
    String query,
  ) {
    return VChatController.I.nativeApi.remote.room
        .searchToMention(roomId, filter: VBaseFilter(name: query));
  }
}
