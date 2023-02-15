// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import '../../core/core.dart';
import '../pinter/image_pinter_view.dart';

class MediaEditorController extends ValueNotifier {
  MediaEditorController(this.platformFiles, this.config) : super(null) {
    _init();
  }

  final List<VPlatformFileSource> platformFiles;
  final mediaFiles = <VBaseMediaRes>[];
  final VMediaEditorConfig config;
  bool isLoading = true;
  bool isCompressing = false;

  int currentImageIndex = 0;

  final pageController = PageController();

  void onEmptyPress(BuildContext context) {
    Navigator.pop(context);
  }

  void onDelete(VBaseMediaRes item, BuildContext context) {
    mediaFiles.remove(item);
    if (mediaFiles.isEmpty) {
      return Navigator.pop(context);
    }
    _updateScreen();
  }

  Future<void> onCrop(VMediaImageRes item, BuildContext context) async {
    final res = await VAppPick.croppedImage(file: item.data.fileSource);
    item.data.fileSource = res!;
    _updateScreen();
  }

  Future onStartEditVideo(
    VMediaVideoRes item,
    BuildContext context,
  ) async {
    // if (item.data.isFromPath) {
    //   final file = await Navigator.push(
    //     context,
    //     MaterialPageRoute<void>(
    //       builder: (BuildContext context) =>
    //           VideoEditor(file: File(item.data.fileSource.filePath!)),
    //     ),
    //   ) as File?;
    //   if (file != null) {
    //     item.data.fileSource.filePath = file.path;
    //   }
    // }
  }

  Future<void> onStartDraw(
    VBaseMediaRes item,
    BuildContext context,
  ) async {
    if (item is VMediaImageRes) {
      final editedFile = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ImagePinterView(
            platformFileSource: item.data.fileSource,
          ),
        ),
      ) as VPlatformFileSource?;
      if (editedFile != null) {
        item.data.fileSource = editedFile;
      }
    }
    _updateScreen();
  }

  void close() {
    pageController.dispose();
  }

  void changeImageIndex(int index) {
    currentImageIndex = index;
    pageController.jumpToPage(index);
    for (final element in mediaFiles) {
      element.isSelected = false;
    }
    mediaFiles[index].isSelected = true;
    _updateScreen();
  }

  void _updateScreen() {
    notifyListeners();
  }

  Future _init() async {
    for (final f in platformFiles) {
      if (f.getMediaType == VSupportedFilesType.image) {
        final mImage = VMediaImageRes(
          data: VMessageImageData(
            fileSource: f,
            width: -1,
            height: -1,
          ),
        );
        mediaFiles.add(mImage);
      } else if (f.getMediaType == VSupportedFilesType.video) {
        VMessageImageData? thumb;
        if (f.filePath != null) {
          thumb = await _getThumb(f.filePath!);
        }
        final mFile = VMediaVideoRes(
          data: VMessageVideoData(
            fileSource: f,
            duration: -1,
            thumbImage: thumb,
          ),
        );
        mediaFiles.add(mFile);
      } else {
        mediaFiles.add(VMediaFileRes(data: f));
      }
    }
    mediaFiles[0].isSelected = true;
    isLoading = false;
    _updateScreen();
    startCompressImagesIfNeed();
  }

  Future<VMessageImageData?> _getThumb(String path) async {
    return VFileUtils.getVideoThumb(
      fileSource: VPlatformFileSource.fromPath(
        filePath: path,
      ),
    );
  }

  void onPlayVideo(VBaseMediaRes item, BuildContext context) {
    if (item is VMediaVideoRes) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VVideoPlayer(
            platformFileSource: item.data.fileSource,
            appName: "media_editor",
          ),
        ),
      );
    }
  }

  Future<void> startCompressImagesIfNeed() async {
    for (final f in mediaFiles) {
      if (f is VMediaImageRes) {
        f.data.fileSource =
            (await VFileUtils.compressImage(fileSource: f.data.fileSource));
      }
      _updateScreen();
    }
  }

  Future<void> onSubmitData(BuildContext context) async {
    isCompressing = true;
    _updateScreen();
    for (final f in mediaFiles) {
      if (f is VMediaImageRes && f.data.isFromPath) {
        final data = await VFileUtils.getImageInfo(
          fileSource: f.data.fileSource,
        );
        f.data.width = data.image.width;
        f.data.height = data.image.height;
      } else if (f is VMediaImageRes && f.data.isFromBytes) {
        final data = await VFileUtils.getImageInfo(
          fileSource: f.data.fileSource,
        );
        f.data.width = data.image.width;
        f.data.height = data.image.height;
      } else if (f is VMediaVideoRes) {
        f.data.duration =
            await VFileUtils.getVideoDurationMill(f.data.fileSource);
      }
    }
    context.pop(mediaFiles);
    //await VideoCompress.deleteAllCache();
  }
}
