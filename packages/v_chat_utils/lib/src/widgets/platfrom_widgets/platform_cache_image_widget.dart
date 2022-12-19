import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../v_chat_utils.dart';

class VPlatformCacheImageWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (source.bytes != null) {
      return Image.memory(
        Uint8List.fromList(source.bytes!),
        width: size == null ? null : size!.width,
        fit: fit,
        height: size == null ? null : size!.height,
      );
    }
    if (source.filePath != null) {
      return Image.file(
        File(source.filePath!),
        width: size == null ? null : size!.width,
        height: size == null ? null : size!.height,
        fit: fit,
      );
    }

    return CachedNetworkImage(
      height: size == null ? null : size!.height,
      width: size == null ? null : size!.width,
      fit: fit,
      imageUrl: source.url!.fullUrl,
      imageBuilder: (context, imageProvider) => DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) =>
          const CupertinoActivityIndicator.partiallyRevealed(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
