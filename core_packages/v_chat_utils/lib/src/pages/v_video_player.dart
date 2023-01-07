import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:v_chat_utils/src/models/models.dart';

class VVideoPlayer extends StatefulWidget {
  final VPlatformFileSource platformFileSource;

  const VVideoPlayer({
    Key? key,
    required this.platformFileSource,
  }) : super(key: key);

  @override
  State<VVideoPlayer> createState() => _VVideoPlayerState();
}

class _VVideoPlayerState extends State<VVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    if (!widget.platformFileSource.isVideo) {
      return Text("the file must be video ${widget.platformFileSource}");
    }
    return Scaffold(
      body: SafeArea(
        child: PhotoView(
          imageProvider: _getImageProvider(),
        ),
      ),
    );
  }

  ImageProvider _getImageProvider() {
    if (widget.platformFileSource.isFromPath) {
      return FileImage(File(widget.platformFileSource.filePath!));
    }
    if (widget.platformFileSource.isFromBytes) {
      return MemoryImage(Uint8List.fromList(widget.platformFileSource.bytes!));
    }
    return CachedNetworkImageProvider(widget.platformFileSource.url!);
  }
}
