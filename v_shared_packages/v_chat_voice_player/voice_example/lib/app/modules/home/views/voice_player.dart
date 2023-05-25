// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:v_chat_voice_player/v_chat_voice_player.dart';
import 'package:v_platform/v_platform.dart';

class VoicePlayer extends StatefulWidget {
  final String url;
  final Duration duration;

  const VoicePlayer({required this.url, required this.duration, Key? key})
      : super(key: key);

  @override
  VoicePlayerState createState() => VoicePlayerState();
}

class VoicePlayerState extends State<VoicePlayer> {
  bool isLoading = true;
  late String path;
  late final VVoiceMessageController messageController;
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();

    return WillPopScope(
      onWillPop: () async {
        messageController.dispose();
        return true;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  if (isLoading)
                    const CircularProgressIndicator.adaptive()
                  else
                    VVoiceMessageView(
                      controller: messageController,
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future download() async {
    try {
      final file = await DefaultCacheManager().getSingleFile(
        widget.url,
      );
      path = file.path;
    } catch (err) {
      //
      rethrow;
    }
  }

  void init() async {
    await download();
    messageController = VVoiceMessageController(
      audioSrc: VPlatformFile.fromPath(fileLocalPath: path),
      maxDuration: widget.duration,
      id: "1",
      onPlaying: (id) {},
      onComplete: (id) {
        if (kDebugMode) {
          print("On onComplete called ! $id");
        }
      },
      onPause: (id) {},
    );
    setState(() {
      isLoading = false;
    });
  }
}
