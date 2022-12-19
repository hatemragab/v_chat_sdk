import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import 'package:video_player/video_player.dart' as vd;

class VideoPlayerView extends StatefulWidget {
  final VMessageVideoData messageVideoData;

  const VideoPlayerView({super.key, required this.messageVideoData});

  @override
  VideoPlayerViewState createState() => VideoPlayerViewState();
}

class VideoPlayerViewState extends State<VideoPlayerView> {
  late vd.VideoPlayerController videoPlayerController;
  bool isLoading = true;

  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            if (isLoading)
              const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            else
              Chewie(
                controller: chewieController!,
              ),
            Positioned(
              top: 20,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 33,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initPlayer() async {
    if (widget.messageVideoData.fileSource.bytes != null) {
      // videoPlayerController = vd.VideoPlayerController.network(
      //   html.V.getVideoPlayer(widget.messageVideoData.fileSource.bytes!),
      // );
      // videoPlayerController = vd.VideoPlayerController.contentUri(
      //   Uri.dataFromBytes(
      //     widget.messageVideoData.fileSource.bytes!,
      //   ),
      // );
    } else {
      videoPlayerController = vd.VideoPlayerController.file(
          File(widget.messageVideoData.fileSource.filePath!));
    }

    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
    );
    isLoading = false;
    setState(() {});
  }
}
