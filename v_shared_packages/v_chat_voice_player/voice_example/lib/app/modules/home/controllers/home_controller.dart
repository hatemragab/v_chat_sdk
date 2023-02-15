// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:get/get.dart';
import 'package:v_chat_voice_player/v_chat_voice_player.dart';

import '../views/home_view.dart';

class MsgVoiceControllersModel {
  final String id;
  final VVoiceMessageController controller;

  MsgVoiceControllersModel(this.id, this.controller);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MsgVoiceControllersModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class HomeController extends GetxController {
  final _voiceControllers = <MsgVoiceControllersModel>[];

  VVoiceMessageController getVoiceController(VoiceMessageModel voice) {
    final item =
        _voiceControllers.firstWhereOrNull((element) => element.id == voice.id);
    if (item == null) {
      final controller = VVoiceMessageController(
        id: voice.id,
        audioSrc: voice.dataSource,
        onComplete: onComplete,
        onPause: (id) {},
        onPlaying: onPlaying,
      );
      _voiceControllers.add(MsgVoiceControllersModel(voice.id, controller));
      return controller;
    }
    return item.controller;
  }

  void onComplete(String id) {
    final maxIndex = _voiceControllers.length - 1;
    final currentControllerIndex =
        _voiceControllers.indexWhere((e) => e.id == id);
    if (currentControllerIndex == -1) {
      return;
    }
    // this mean it is the last message
    if (currentControllerIndex == maxIndex) {
      return;
    }
    if (maxIndex != currentControllerIndex) {
      _voiceControllers[currentControllerIndex - 1].controller.initAndPlay();
    }
  }

  void onPlaying(String id) {
    for (var e in _voiceControllers) {
      if (e.id != id) {
        if (e.controller.isPlaying) {
          e.controller.pausePlaying();
        }
      }
    }
  }
}
