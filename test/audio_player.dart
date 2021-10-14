import 'package:audioplayers/audioplayers.dart';

class TestAudioPlayer {
  void urlPlay() async {
    AudioPlayer audioPlayer = AudioPlayer();
    int result = await audioPlayer.play(
        "http://192.168.1.10:3000/api/v1/public/messages/1633769363798.m4a");
  }
}
