import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../v_chat_utils.dart';

class VVideoPlayer extends StatefulWidget {
  final VPlatformFileSource platformFileSource;
  final String appName;
  final String successfullyDownloaded;

  const VVideoPlayer({
    Key? key,
    required this.platformFileSource,
    required this.appName,
    required this.successfullyDownloaded,
  }) : super(key: key);

  @override
  State<VVideoPlayer> createState() => _VVideoPlayerState();
}

class _VVideoPlayerState extends State<VVideoPlayer> {
  bool isLoading = true;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initAndPlay();
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.platformFileSource.isContentVideo) {
      return Material(
          child: Text("the file must be video ${widget.platformFileSource}"));
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: widget.platformFileSource.isFromUrl
          ? FloatingActionButton(
              child: const Icon(Icons.save_alt),
              onPressed: () async {
                VAppAlert.showLoading(context: context);
                final url = await VFileUtils.saveFileToPublicPath(
                  fileAttachment: widget.platformFileSource,
                  appName: widget.appName,
                );
                context.pop();
                VAppAlert.showSuccessSnackBar(
                  msg: "${widget.successfullyDownloaded}to $url",
                  context: context,
                );
              },
            )
          : null,
      body: SafeArea(
        child: Center(
          child: VConditionalBuilder(
            condition: !isLoading,
            thenBuilder: () => AspectRatio(
              aspectRatio: _videoPlayerController!.value.aspectRatio,
              child: Chewie(
                controller: _chewieController!,
              ),
            ),
            elseBuilder: () => const CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
    );
  }

  void _initAndPlay() async {
    if (widget.platformFileSource.isFromPath) {
      _videoPlayerController = VideoPlayerController.file(
        File(widget.platformFileSource.filePath!),
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: false),
      );
    } else if (widget.platformFileSource.isFromBytes) {
      _videoPlayerController = VideoPlayerController.contentUri(
        Uri.dataFromBytes(widget.platformFileSource.getBytes),
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: false),
      );
    } else if (widget.platformFileSource.isFromAssets) {
      _videoPlayerController = VideoPlayerController.asset(
        widget.platformFileSource.assetsPath!,
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: false),
      );
    } else if (widget.platformFileSource.isFromUrl) {
      _videoPlayerController = VideoPlayerController.network(
        widget.platformFileSource.url!,
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: false),
      );
    }

    await _videoPlayerController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
    );
    setState(() {
      isLoading = false;
    });
  }
}
