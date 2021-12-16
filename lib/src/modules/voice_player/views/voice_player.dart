import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:textless/textless.dart';

import 'package:v_chat_sdk/src/utils/custom_widgets/audio_wave.dart';
import '../../../models/v_chat_message.dart';
import '../../../utils/api_utils/server_config.dart';

class VoicePlayer extends StatefulWidget {
  final VChatMessage message;

  const VoicePlayer({required this.message, Key? key}) : super(key: key);

  @override
  _VoicePlayerState createState() => _VoicePlayerState();
}

class _VoicePlayerState extends State<VoicePlayer> {
  bool isLoading = true;
  bool isPlaying = true;
  final audioPlayer = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startPlayVoice();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.white,
          child: Material(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 100,
                  child: isPlaying
                      ? InkWell(
                          onTap: pauseVoice,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(
                              color: Colors.indigo,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.pause,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        )
                      : isLoading
                          ? const SizedBox(
                              height: 50,
                              width: 50,
                              child: CupertinoActivityIndicator(),
                            )
                          : InkWell(
                              onTap: startPlayVoice,
                              child: const SizedBox(
                                height: 50,
                                width: 50,
                                child: Icon(
                                  Icons.play_circle,
                                  color: Colors.indigo,
                                  size: 40,
                                ),
                              ),
                            ),
                ),
                widget.message.messageAttachment!.fileDuration!.h6,
                const SizedBox(
                  width: 20,
                ),
                AudioWave(
                  height: 32,
                  animation: isPlaying,
                  spacing: 2.5,
                  width: MediaQuery.of(context).size.width / 2,
                  bars: [
                    AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
                    AudioWaveBar(height: 30, color: Colors.blue),
                    AudioWaveBar(height: 70, color: Colors.black),
                    AudioWaveBar(height: 40),
                    AudioWaveBar(height: 20, color: Colors.orange),
                    AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
                    AudioWaveBar(height: 30, color: Colors.blue),
                    AudioWaveBar(height: 70, color: Colors.black),
                    AudioWaveBar(height: 40),
                    AudioWaveBar(height: 20, color: Colors.orange),
                    AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
                    AudioWaveBar(height: 30, color: Colors.blue),
                    AudioWaveBar(height: 70, color: Colors.black),
                    AudioWaveBar(height: 40),
                    AudioWaveBar(height: 20, color: Colors.orange),
                    AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
                    AudioWaveBar(height: 30, color: Colors.blue),
                    AudioWaveBar(height: 70, color: Colors.black),
                    AudioWaveBar(height: 40),
                    AudioWaveBar(height: 20, color: Colors.orange),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    stopPlayer();
    super.dispose();
  }

  void stopPlayer() {
    audioPlayer.dispose();
  }

  Future<void> startPlayVoice() async {
    await audioPlayer.play(
      ServerConfig.messagesMediaBaseUrl +
          widget.message.messageAttachment!.playUrl!,
      stayAwake: true,
    );
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        isLoading = false;
      });
    });
    setState(() {
      isPlaying = true;
    });
    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  Future<void> pauseVoice() async {
    await audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }
}
