// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:v_chat_message_page/src/v_chat/v_app_alert.dart';
import 'package:v_chat_message_page/src/v_chat/v_file.dart';
import 'package:v_chat_message_page/src/v_chat/v_safe_api_call.dart';
import 'package:v_platform/v_platform.dart';

class VImageViewer extends StatefulWidget {
  final VPlatformFile platformFileSource;
  final String downloadingLabel;
  final String successfullyDownloadedInLabel;

  const VImageViewer({
    Key? key,
    required this.platformFileSource,
    required this.downloadingLabel,
    required this.successfullyDownloadedInLabel,
  }) : super(key: key);

  @override
  State<VImageViewer> createState() => _VImageViewerState();
}

class _VImageViewerState extends State<VImageViewer> {
  @override
  Widget build(BuildContext context) {
    if (!widget.platformFileSource.isContentImage) {
      return Material(
          child: Text("the file must be image ${widget.platformFileSource}"));
    }
    return Dismissible(
      key: const Key('photo_view_gallery'),
      direction: DismissDirection.down,
      onDismissed: (direction) {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: PhotoView(
          imageProvider: _getImageProvider(),
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
                    onError: (exception, trace) {
                      if (kDebugMode) {
                        print(exception);
                      }
                    },
                  );
                },
              )
            : null,
      ),
    );
  }

  ImageProvider _getImageProvider() {
    if (widget.platformFileSource.isFromPath) {
      return FileImage(File(widget.platformFileSource.fileLocalPath!));
    }
    if (widget.platformFileSource.isFromBytes) {
      return MemoryImage(Uint8List.fromList(widget.platformFileSource.bytes!));
    }
    return CachedNetworkImageProvider(
      widget.platformFileSource.url!,
      cacheKey: widget.platformFileSource.getUrlPath,
    );
  }
}
