import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart' as vd;

class VideoPlayerView extends StatefulWidget {
  final String url;

  const VideoPlayerView(this.url);

  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late vd.VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Chewie(
                    controller: chewieController,
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
                      )),
                ],
              ));
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  void initPlayer() async {
    videoPlayerController = vd.VideoPlayerController.network(widget.url);
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      allowedScreenSleep: false,
      aspectRatio: videoPlayerController.value.aspectRatio,
      fullScreenByDefault: false,
    );
    isLoading = false;
    setState(() {});
  }
}
