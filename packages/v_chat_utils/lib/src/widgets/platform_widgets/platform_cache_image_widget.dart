import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../v_chat_utils.dart';

class VPlatformCacheImageWidget extends StatefulWidget {
  final VPlatformFileSource source;
  final Size? size;
  final BoxFit? fit;

  const VPlatformCacheImageWidget({
    super.key,
    required this.source,
    this.size,
    this.fit,
  });

  @override
  State<VPlatformCacheImageWidget> createState() =>
      _VPlatformCacheImageWidgetState();
}

class _VPlatformCacheImageWidgetState extends State<VPlatformCacheImageWidget> {
  var imageKey = UniqueKey();
  @override
  Widget build(BuildContext context) {
    if (widget.source.bytes != null) {
      return Image.memory(
        Uint8List.fromList(widget.source.bytes!),
        width: widget.size == null ? null : widget.size!.width,
        fit: widget.fit,
        height: widget.size == null ? null : widget.size!.height,
      );
    }
    if (widget.source.filePath != null) {
      return Image.file(
        File(widget.source.filePath!),
        width: widget.size == null ? null : widget.size!.width,
        height: widget.size == null ? null : widget.size!.height,
        fit: widget.fit,
      );
    }

    return CachedNetworkImage(
      key: imageKey,
      height: widget.size == null ? null : widget.size!.height,
      width: widget.size == null ? null : widget.size!.width,
      fit: widget.fit,
      matchTextDirection: true,
      imageUrl: widget.source.url!.fullUrl,
      placeholder: (context, url) =>
          const CupertinoActivityIndicator.partiallyRevealed(),
      errorWidget: (context, url, error) => InkWell(
        onTap: () {
          setState(() {
            imageKey = UniqueKey();
          });
        },
        child: const Icon(
          Icons.refresh,
        ),
      ),
    );
  }
}
