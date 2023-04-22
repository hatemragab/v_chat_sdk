// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:v_chat_message_page/src/core/stream_mixin.dart';
import 'package:v_chat_message_page/src/page/message_pages/controllers/v_base_message_controller.dart';
import 'package:v_chat_message_page/src/page/message_pages/pages/group/group_app_bar_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VGroupController extends VBaseMessageController with StreamMix {
  final GroupAppBarController groupAppBarController;
  final String _cacheKey = "group-info-";

  VGroupController({
    required super.vRoom,
    required super.context,
    required super.vMessageConfig,
    required super.messageProvider,
    required super.scrollController,
    required super.inputStateController,
    required super.itemController,
    required this.groupAppBarController,
  }) {
    _initStreams();
    _getFromCache();
    _updateMyInfoRemote();
  }

  @override
  void close() {
    groupAppBarController.close();
    closeStreamMix();
    super.close();
  }

  @override
  void onOpenSearch() {
    groupAppBarController.onOpenSearch();
    super.onOpenSearch();
  }

  Future<void> _getFromCache() async {
    final res = VAppPref.getMap("$_cacheKey${vRoom.id}");
    if (res == null) return;
    final info = VMyGroupInfo.fromMap(res);
    _updateInputState(info);
    groupAppBarController.updateValue(info);
  }

  Future<void> _updateMyInfoRemote() async {
    await vSafeApiCall<VMyGroupInfo>(
      request: () {
        return VChatController.I.roomApi.getGroupVMyGroupInfo(roomId: vRoom.id);
      },
      onSuccess: (response) async {
        groupAppBarController.updateValue(response);
        _updateInputState(response);
        await VAppPref.setMap("$_cacheKey${vRoom.id}", response.toMap());
      },
    );
  }

  void _updateInputState(VMyGroupInfo info) {
    if (info.isMeOut) {
      inputStateController.closeChat();
    } else {
      inputStateController.openChat();
    }
  }

  @override
  void onCloseSearch() {
    groupAppBarController.onCloseSearch();
    super.onCloseSearch();
  }

  @override
  void onTitlePress(BuildContext context) {
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

  @override
  Future<List<VMentionModel>> onMentionRequireSearch(
    BuildContext context,
    String query,
  ) {
    return VChatController.I.nativeApi.remote.room
        .searchToMention(roomId, filter: VBaseFilter(name: query));
  }

  void _initStreams() {
    streamsMix.add(
      VEventBusSingleton.vEventBus
          .on<VOnGroupKicked>()
          .where((e) => e.roomId == vRoom.id)
          .listen(_onGroupKick),
    );
  }

  void _onGroupKick(VOnGroupKicked event) {
    inputStateController.closeChat();
  }
}
