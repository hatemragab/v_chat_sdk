// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

class VPlatformCacheImageWidget extends StatefulWidget {
  final VPlatformFile source;
  final Size? size;
  final BoxFit? fit;
  final BorderRadius? borderRadius;

  const VPlatformCacheImageWidget({
    super.key,
    required this.source,
    this.size,
    this.fit,
    this.borderRadius,
  });

  @override
  State<VPlatformCacheImageWidget> createState() =>
      _VPlatformCacheImageWidgetState();
}

class _VPlatformCacheImageWidgetState extends State<VPlatformCacheImageWidget> {
  var imageKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    if (widget.borderRadius != null) {
      return ClipRRect(
        borderRadius: widget.borderRadius!,
        child: _getImage(),
      );
    }
    return _getImage();
  }

  Widget _getImage() {
    if (widget.source.isFromAssets) {
      return Image.asset(
        widget.source.assetsPath!,
        width: widget.size?.width,
        fit: widget.fit,
        height: widget.size?.height,
      );
    }
    if (widget.source.isFromBytes) {
      return Image.memory(
        Uint8List.fromList(widget.source.bytes!),
        width: widget.size?.width,
        fit: widget.fit,
        height: widget.size?.height,
      );
    }
    if (widget.source.fileLocalPath != null) {
      return Image.file(
        File(widget.source.fileLocalPath!),
        width: widget.size?.width,
        height: widget.size?.height,
        fit: widget.fit,
      );
    }
    return CachedNetworkImage(
      key: imageKey,
      height: widget.size?.height,
      width: widget.size?.width,
      fit: widget.fit,
      cacheKey: widget.source.getUrlPath,
      imageUrl: widget.source.url!,
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
