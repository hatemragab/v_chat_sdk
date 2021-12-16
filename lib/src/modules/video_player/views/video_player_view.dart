import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart' as vd;
import 'package:video_viewer/video_viewer.dart';

class VideoPlayerView extends StatefulWidget {
  final String url;

  const VideoPlayerView(this.url, {Key? key}) : super(key: key);

  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late vd.VideoPlayerController videoPlayerController;
  bool isLoading = true;

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
            VideoViewer(
              autoPlay: true,
              source: {
                "SubRip Text": VideoSource(
                  video: vd.VideoPlayerController.network(widget.url),
                )
              },
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
    videoPlayerController = vd.VideoPlayerController.network(widget.url);
    await videoPlayerController.initialize();

    isLoading = false;
    setState(() {});
  }
}
