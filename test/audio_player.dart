import 'package:audioplayers/audioplayers.dart';

class TestAudioPlayer {
  void urlPlay() async {
    //https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_1MG.mp3
    AudioPlayer audioPlayer = AudioPlayer();
    int result = await audioPlayer.play(
        "http://ec2-3-142-209-237.us-east-2.compute.amazonaws.com:3000/api/v1/public/messages/1635246286427.m4a");

  }
}
