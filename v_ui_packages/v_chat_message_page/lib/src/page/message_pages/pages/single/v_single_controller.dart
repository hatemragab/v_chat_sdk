// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:v_chat_message_page/src/page/message_pages/pages/single/single_app_bar_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../../v_chat_message_page.dart';
import '../../../../v_chat/app_pref.dart';
import '../../../../v_chat/v_app_alert.dart';
import '../../../../v_chat/v_safe_api_call.dart';

class VSingleController extends VBaseMessageController with StreamMix {
  final SingleAppBarController singleAppBarController;
  final VMessageLocalization language;
  VSingleController({
    required super.vRoom,
    required super.context,
    required super.messageProvider,
    required super.scrollController,
    required super.inputStateController,
    required super.itemController,
    required this.singleAppBarController,
    required super.vMessageConfig,
    required this.language,
  }) {
    _initStreams();
    _getFromCache();
    _checkBanRemote();
  }

  @override
  void close() {
    singleAppBarController.close();
    closeStreamMix();
    super.close();
  }

  @override
  void onOpenSearch() {
    singleAppBarController.onOpenSearch();
    super.onOpenSearch();
  }

  @override
  void onCloseSearch() {
    singleAppBarController.onCloseSearch();
    super.onCloseSearch();
  }

  @override
  void onTitlePress(BuildContext context) {
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
      title: language.makeCall,
      cancel: language.cancel,
      ok: language.ok,
      content: isVideo
          ? language.areYouWantToMakeVideoCall
          : language.areYouWantToMakeVoiceCall,
    );
    if (res != 1) return;
    VChatController.I.vNavigator.callNavigator?.toCall(
      context,
      VCallDto(
        isVideoEnable: isVideo,
        roomId: vRoom.id,
        isCaller: true,
        peerUser: VBaseUser(
          vChatId: vRoom.peerId!,
          fullName: vRoom.title,
          userImages: VUserImage.fromSingleUrl(
            vRoom.thumbImage,
          ),
        ),
      ),
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
  Future<List<MentionModel>> onMentionRequireSearch(
      BuildContext context, String query) {
    return Future(() => []);
  }

  void _initStreams() {
    streamsMix.add(VEventBusSingleton.vEventBus
        .on<VSingleBlockEvent>()
        .where((e) => e.roomId == vRoom.id)
        .listen(_handleBlockEvent));
  }

  void _handleBlockEvent(VSingleBlockEvent event) async {
    await updateValue(event.banModel);
    if (event.banModel.isThereBan) {
      inputStateController.closeChat();
    } else {
      inputStateController.openChat();
    }
  }

  Future<void> _getFromCache() async {
    final res = VAppPref.getMap("ban-${vRoom.id}");
    if (res == null) return;
    updateValue(VSingleBlockModel.fromMap(res));
  }

  Future<void> updateValue(VSingleBlockModel value) async {
    await VAppPref.setMap("ban-${vRoom.id}", value.toMap());
    if (value.isThereBan) {
      inputStateController.closeChat();
    } else {
      inputStateController.openChat();
    }
  }

  Future<void> _checkBanRemote() async {
    if (vRoom.roomType.isSingleOrOrder) {
      await vSafeApiCall<VSingleBlockModel>(
        request: () {
          return VChatController.I.blockApi
              .checkIfThereBan(peerIdentifier: vRoom.peerIdentifier!);
        },
        onSuccess: (response) async {
          await updateValue(response);
        },
      );
    }
  }
}
