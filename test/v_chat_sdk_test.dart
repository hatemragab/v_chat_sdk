import 'package:flutter_test/flutter_test.dart';

import 'audio_player.dart';

void main() {
  test('if audio player works', () {
   final a = TestAudioPlayer();
   a.urlPlay();

  });
}
