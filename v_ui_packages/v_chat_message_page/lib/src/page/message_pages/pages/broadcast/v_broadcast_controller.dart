// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:v_chat_input_ui/v_chat_input_ui.dart';
import 'package:v_chat_message_page/src/page/message_pages/controllers/v_base_message_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import 'broadcast_app_bar_controller.dart';

class VBroadcastController extends VBaseMessageController {
  final BroadcastAppBarController broadcastAppBarController;

  VBroadcastController({
    required super.vRoom,
    required super.context,
    required super.messageProvider,
    required super.scrollController,
    required super.inputStateController,
    required super.itemController,
    required super.vMessageConfig,
    required this.broadcastAppBarController,
  });

  @override
  void close() {
    super.close();
    broadcastAppBarController.close();
  }

  @override
  void onOpenSearch() {
    broadcastAppBarController.onOpenSearch();
    super.onOpenSearch();
  }

  @override
  void onCloseSearch() {
    broadcastAppBarController.onCloseSearch();
    super.onCloseSearch();
  }

  @override
  void onTitlePress(BuildContext context) {
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

  @override
  Future<List<MentionModel>> onMentionRequireSearch(
      BuildContext context, String query) async {
    return <MentionModel>[];
  }
}
