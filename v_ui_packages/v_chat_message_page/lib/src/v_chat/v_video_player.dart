// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:v_chat_message_page/src/v_chat/v_app_alert.dart';
import 'package:v_chat_message_page/src/v_chat/v_file.dart';
import 'package:v_chat_message_page/src/v_chat/v_safe_api_call.dart';
import 'package:v_platform/v_platform.dart';
import 'package:video_player/video_player.dart';

import 'conditional_builder.dart';

class VVideoPlayer extends StatefulWidget {
  final VPlatformFile platformFileSource;
  final String downloadingLabel;
  final String successfullyDownloadedInLabel;
  const VVideoPlayer({
    Key? key,
    required this.platformFileSource,
    required this.downloadingLabel,
    required this.successfullyDownloadedInLabel,
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
                await vSafeApiCall<String>(
                  onLoading: () {
                    VAppAlert.showSuccessSnackBar(
                      msg: widget.downloadingLabel,
                      context: context,
                    );
                  },
                  request: () async {
                    return VFileUtils.saveFileToPublicPath(
                      fileAttachment: widget.platformFileSource,
                    );
                  },
                  onSuccess: (url) async {
                    VAppAlert.showSuccessSnackBar(
                      msg: widget.successfullyDownloadedInLabel + url,
                      context: context,
                    );
                  },
                  onError: (exception, trace) {},
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
    VideoPlayerController? controller;
    VideoPlayerOptions options =
        VideoPlayerOptions(allowBackgroundPlayback: false);
    if (widget.platformFileSource.isFromPath) {
      controller = VideoPlayerController.file(
        File(widget.platformFileSource.fileLocalPath!),
        videoPlayerOptions: options,
      );
    } else if (widget.platformFileSource.isFromBytes) {
      controller = VideoPlayerController.contentUri(
        Uri.dataFromBytes(widget.platformFileSource.getBytes),
        videoPlayerOptions: options,
      );
    } else if (widget.platformFileSource.isFromAssets) {
      controller = VideoPlayerController.asset(
        widget.platformFileSource.assetsPath!,
        videoPlayerOptions: options,
      );
    } else if (widget.platformFileSource.isFromUrl) {
      final file = await (VPlatforms.isMobile
          ? DefaultCacheManager().getSingleFile(
              widget.platformFileSource.url!,
              key: widget.platformFileSource.getUrlPath,
            )
          : null);
      controller = file != null
          ? VideoPlayerController.file(file, videoPlayerOptions: options)
          : VideoPlayerController.network(
              widget.platformFileSource.url!,
              videoPlayerOptions: options,
            );
    }

    if (controller != null) {
      await controller.initialize();
      setState(() {
        _videoPlayerController = controller;
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: true,
          looping: false,
        );
        isLoading = false;
      });
    }
  }
}
