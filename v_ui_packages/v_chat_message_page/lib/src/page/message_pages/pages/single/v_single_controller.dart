// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:v_chat_message_page/src/page/message_pages/controllers/v_base_message_controller.dart';
import 'package:v_chat_message_page/src/page/message_pages/states/block_state_controller.dart';
import 'package:v_chat_message_page/src/page/message_pages/states/last_seen_state_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../controllers/message_stream_state_controller.dart';

class VSingleController extends VBaseMessageController {
  LastSeenStateController? lastSeenStateController;
  late final MessageStreamState _localStreamChanges;

  VSingleController({
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
    final toSingleSettings =
        VChatController.I.vNavigator.messageNavigator.toSingleSettings;
    if (toSingleSettings == null) return;
    toSingleSettings(
      context,
      VToChatSettingsModel(
        title: vRoom.title,
        image: vRoom.thumbImage,
        roomId: roomId,
        room: vRoom,
      ),
      vRoom.peerIdentifier!,
    );
  }

  void onCreateCall(bool isVideo) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: VTrans.labelsOf(context).makeCall,
      content: isVideo
          ? VTrans.labelsOf(context).areYouWantToMakeVideoCall
          : VTrans.labelsOf(context).areYouWantToMakeVoiceCall,
    );
    if (res != 1) return;
    VChatController.I.vNavigator.callNavigator.toCaller(
      context,
      VCallerDto(
        isVideoEnable: isVideo,
        roomId: vRoom.id,
        peerImage: vRoom.thumbImage,
        peerName: vRoom.title,
      ),
    );
  }

  void _initStates() {
    lastSeenStateController = LastSeenStateController(
      appBarStateController,
      vRoom,
      messageProvider,
    );

    _localStreamChanges = MessageStreamState(
      nativeApi: VChatController.I.nativeApi,
      messageState: this,
      appBarStateController: appBarStateController,
      inputStateController: inputStateController,
      currentRoom: vRoom,
      blockStateController: BlockStateController(inputStateController, vRoom),
    );
  }

  Future onUpdateBlock(bool isBlocked) async {
    vSafeApiCall(
      request: () async {
        if (isBlocked) {
          return VChatController.I.blockApi
              .blockUser(peerIdentifier: vRoom.peerIdentifier!);
        } else {
          return VChatController.I.blockApi
              .unBlockUser(peerIdentifier: vRoom.peerIdentifier!);
        }
      },
      onSuccess: (response) {},
    );
  }

  @override
  Future<List<VMentionModel>> onMentionRequireSearch(
      BuildContext context, String query) {
    return Future(() => []);
  }
}
