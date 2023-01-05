import 'package:collection/collection.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_voice_player/v_chat_voice_player.dart';

class VVoicePlayerController {
  final _voiceControllers = <VVoiceMessageController>[];

  VVoiceMessageController? getVoiceController(VBaseMessage voiceMessage) {
    if (voiceMessage is VVoiceMessage) {
      final c = _voiceControllers
          .firstWhereOrNull((e) => e.id == voiceMessage.localId);
      if (c != null) {
        return c;
      }
      final controller = VVoiceMessageController(
        id: voiceMessage.localId,
        audioSrc: voiceMessage.data.fileSource,
        onComplete: (String id) {
          //todo play the next voice
        },
        maxDuration: voiceMessage.data.durationObj,
        onPause: (String id) {},
        onPlaying: _onPlaying,
      );
      _voiceControllers.add(controller);
      return controller;
    }
    return null;
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
      c.pausePlaying();
    }
  }
}
