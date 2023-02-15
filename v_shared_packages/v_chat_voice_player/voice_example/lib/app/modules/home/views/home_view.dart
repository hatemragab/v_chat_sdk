// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import 'package:v_chat_voice_player/v_chat_voice_player.dart';
import 'package:voice_example/app/modules/home/views/voice_player.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final controller = Get.find<HomeController>();
  final voicesList = <VoiceMessageModel>[];
  final url =
      "https://super-up-vchat.s3.eu-west-3.amazonaws.com/v-media/63d6683a88c3d52e0e6dffa4/media600-d790a399-7b9a-469f-adfa-85695351cb7b.webm?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIASLNW35LCAS2545PY%2F20230209%2Feu-west-3%2Fs3%2Faws4_request&X-Amz-Date=20230209T230152Z&X-Amz-Expires=432000&X-Amz-Signature=165fa27124326019a9fff8eb87e285603782fb654c7f26a306afd4de295ab24b&X-Amz-SignedHeaders=host";

  @override
  void initState() {
    super.initState();
    voicesList.addAll(List.generate(
      100,
      (i) => VoiceMessageModel(
        id: "$i",
        // dataSource: VPlatformFileSource.fromUrl(
        //   url: "https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.mp3",
        // ),
        dataSource: VPlatformFileSource.fromUrl(
          url: url,
        ),
      ),
    ));
  }

  // void onComplete(String id) {
  //   final cIndex = list.indexWhere((e) => e.id == id);
  //   if (cIndex == -1) {
  //     return;
  //   }
  //   if (cIndex == list.length - 1) {
  //     return;
  //   }
  //   if (list.length - 1 != cIndex) {
  //     list[cIndex + 1].controller.initAndPlay();
  //   }
  // }
  //
  // void onPlaying(String id) {
  //   for (var e in list) {
  //     if (e.id != id) {
  //       if (e.controller.isPlaying) {
  //         e.controller.pausePlaying();
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example"),
        centerTitle: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            elevation: 0,
            heroTag: "cc",
            onPressed: () {
              voicesList.insert(
                0,
                VoiceMessageModel(
                    id: "${DateTime.now().millisecond}",
                    dataSource: VPlatformFileSource.fromUrl(
                      url:
                          "https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.mp3",
                    )),
              );
              setState(() {});
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            height: 10,
          ),
          kIsWeb
              ? const SizedBox()
              : FloatingActionButton(
                  elevation: 0,
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return const VoicePlayer(
                          duration: Duration(seconds: 7, minutes: 3),
                          url:
                              "https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.mp3",
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.music_note),
                ),
        ],
      ),
      body: SizedBox(
        width: 400,
        child: ListView.separated(
          padding: const EdgeInsets.all(10),
          reverse: true,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, i) {
            return VVoiceMessageView(
              controller: controller.getVoiceController(voicesList[i]),
              key: ValueKey(voicesList[i].id),
            );
          },
          itemCount: voicesList.length,
        ),
      ),
    );
  }
}

class VoiceMessageModel {
  final String id;
  final VPlatformFileSource dataSource;
  final int? maxDuration;

  VoiceMessageModel({
    required this.id,
    required this.dataSource,
    this.maxDuration,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoiceMessageModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
