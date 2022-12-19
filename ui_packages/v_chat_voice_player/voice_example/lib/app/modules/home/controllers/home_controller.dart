import 'package:get/get.dart';
import 'package:v_chat_voice_player/v_chat_voice_player.dart';

import '../views/home_view.dart';

class HomeController extends GetxController {
  final Map<String, VoiceMessageController> _voiceControllers = {};

  VoiceMessageController getVoiceController(VoiceMessageModel voice) {
    final item = _voiceControllers[voice.id];
    if (item == null) {
      final controller = VoiceMessageController(
        id: voice.id,
        audioSrc: voice.dataSource,
        onComplete: (id) {},
        onPause: (id) {},
        onPlaying: (id) {},
      );
      _voiceControllers.addAll({voice.id: controller});
      return controller;
    }
    return item;
  }
}
