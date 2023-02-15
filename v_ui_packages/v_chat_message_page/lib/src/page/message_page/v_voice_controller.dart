// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import 'package:v_chat_voice_player/v_chat_voice_player.dart';

class VVoicePlayerController {
  final _voiceControllers = <VVoiceMessageController>[];
  final String? Function(String localId) onVoiceNeedToPlayNext;

  VVoicePlayerController(this.onVoiceNeedToPlayNext);

  VVoiceMessageController? getById(String id) =>
      _voiceControllers.firstWhereOrNull((e) => e.id == id);

  VVoiceMessageController getVoiceController(VVoiceMessage voiceMessage) {
    final oldController = getById(voiceMessage.localId);

    if (oldController != null) return oldController;

    final controller = VVoiceMessageController(
      id: voiceMessage.localId,
      audioSrc: voiceMessage.data.fileSource,
      onComplete: (String localId) {
        final nextId = onVoiceNeedToPlayNext(localId);
        if (nextId != null) {
          getById(nextId)?.initAndPlay();
        }
      },
      maxDuration: voiceMessage.data.durationObj,
      onPlaying: _onPlaying,
    );
    _voiceControllers.add(controller);
    return controller;
  }

  void _onPlaying(String id) {
    for (final controller in _voiceControllers) {
      if (controller.id != id) {
        controller.pausePlaying();
      }
    }
  }

  void close() {
    for (final c in _voiceControllers) {
      c.dispose();
    }
  }
}
