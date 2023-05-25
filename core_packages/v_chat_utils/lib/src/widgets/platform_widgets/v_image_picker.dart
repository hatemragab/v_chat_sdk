// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_utils/src/utils/app_pick.dart';
import 'package:v_chat_utils/src/widgets/platform_widgets/platform_cache_image_widget.dart';
import 'package:v_platform/v_platform.dart';

class VImagePicker extends StatefulWidget {
  final bool withCrop;
  final bool isFromCamera;
  final void Function(VPlatformFile file) onDone;
  final int size;
  final VPlatformFile initImage;

  const VImagePicker({
    Key? key,
    this.withCrop = true,
    this.isFromCamera = false,
    required this.onDone,
    required this.initImage,
    this.size = 70,
  }) : super(key: key);

  @override
  State<VImagePicker> createState() => _VImagePickerState();
}

class _VImagePickerState extends State<VImagePicker> {
  late VPlatformFile current;

  @override
  void initState() {
    super.initState();
    current = widget.initImage;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size.toDouble(),
      width: widget.size.toDouble(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          VPlatformCacheImageWidget(
            source: current,
            borderRadius: BorderRadius.circular(130),
            fit: BoxFit.cover,
            size: Size.fromHeight(widget.size.toDouble()),
          ),
          PositionedDirectional(
            bottom: 1,
            end: 1,
            child: InkWell(
              onTap: _getImage,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightGreen,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.black87,
                  size: 19,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _getImage() async {
    if (!widget.withCrop) {
      final image = await VAppPick.getImage(
        isFromCamera: widget.isFromCamera,
      );
      if (image == null) return;
      setState(() {
        current = image;
      });
      widget.onDone(image);
      return;
    }
    final image = await VAppPick.getCroppedImage(
      isFromCamera: widget.isFromCamera,
    );
    if (image == null) return;
    setState(() {
      current = image;
    });
    widget.onDone(image);
  }
}
