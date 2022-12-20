import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_cropping/image_cropping.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../core/core.dart';
import '../pinter/image_pinter_view.dart';
import '../video_player/views/video_player_view.dart';

class MediaEditorController {
  MediaEditorController(this.platformFiles, this.config) {
    _init();
  }

  final List<VPlatformFileSource> platformFiles;
  final mediaFiles = <VBaseMediaEditor>[];
  final MediaEditorConfig config;
  bool isLoading = true;
  bool isCompressing = false;

  int currentImageIndex = 0;
  ValueNotifier updater = ValueNotifier(null);

  final pageController = PageController();

  void onEmptyPress(BuildContext context) {
    Navigator.pop(context);
  }

  void onDelete(VBaseMediaEditor item, BuildContext context) {
    mediaFiles.remove(item);
    if (mediaFiles.isEmpty) {
      return Navigator.pop(context);
    }
    _updateScreen();
  }

  Future<void> onCrop(VMediaEditorImage item, BuildContext context) async {
    if (item.data.isFromPath) {
      final path = await _ioImageCropper(item.data.fileSource.filePath!);
      if (path != null) {
        item.data.fileSource.filePath = path;
      }
      _updateScreen();
      return;
    }
    final croppedBytes = await ImageCropping.cropImage(
      context: context,
      imageBytes: Uint8List.fromList(item.data.fileSource.bytes!),
      onImageStartLoading: () {},
      onImageEndLoading: () {},
      //selectedImageRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      visibleOtherAspectRatios: true,
      squareBorderWidth: 2,
      squareCircleColor: Colors.black,
      defaultTextColor: Colors.orange,
      selectedTextColor: Colors.black,
      colorForWhiteSpace: Colors.grey,
      encodingQuality: 80,
      outputImageFormat: OutputImageFormat.jpg,
      workerPath: 'crop_worker.js',
      onImageDoneListener: (x) {},
    );
    if (croppedBytes != null) {
      item.data.fileSource.bytes = croppedBytes;
      _updateScreen();
    }
  }

  Future onStartEditVideo(
    VMediaEditorVideo item,
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
    VBaseMediaEditor item,
    BuildContext context,
  ) async {
    if (item is VMediaEditorImage) {
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
    updater.notifyListeners();
  }

  Future _init() async {
    for (final f in platformFiles) {
      if (f.getMediaType == VSupportedFilesType.image) {
        final mImage = VMediaEditorImage(
          data: VMessageImageData(
            fileSource: f,
            width: -1,
            height: -1,
          ),
        );
        mediaFiles.add(mImage);
      } else if (f.getMediaType == VSupportedFilesType.video) {
        late VMessageImageData? thumb;
        if (f.filePath != null) {
          thumb = await _getThumb(f.filePath!);
        }
        final mFile = VMediaEditorVideo(
          data: VMessageVideoData(
            fileSource: f,
            duration: -1,
            thumbImage: thumb,
          ),
        );
        mediaFiles.add(mFile);
      } else {
        mediaFiles.add(VMediaEditorFile(data: f));
      }
    }
    mediaFiles[0].isSelected = true;
    isLoading = false;
    _updateScreen();
    startCompressImagesIfNeed();
  }

  Future<VMessageImageData?> _getThumb(String path) async {
    final thumbPath = await VideoThumbnail.thumbnailFile(
      video: path,
      maxWidth: 600,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
    if (thumbPath == null) return null;
    final thumbImageData = await _getImageInfo(path: thumbPath);
    return VMessageImageData(
      fileSource: VPlatformFileSource.fromPath(filePath: thumbPath),
      width: thumbImageData.image.width,
      height: thumbImageData.image.height,
    );
  }

  Future<File> _compressIoImage(String path) async {
    File compressedFile = File(path);
    if (compressedFile.lengthSync() > 1500 * 1000) {
      // compress only images bigger than 1500 kb
      compressedFile = await FlutterNativeImage.compressImage(
        path,
        quality: 50,
        //targetWidth: 700,
        // targetHeight: (properties.height! * 700 / properties.width!).round(),
      );
    }
    return compressedFile;
  }

  Future<List<int>> _compressJsImage(List<int> bytes) async {
    return bytes;
  }

  void onPlayVideo(VBaseMediaEditor item, BuildContext context) {
    if (item is VMediaEditorVideo) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoPlayerView(
            messageVideoData: item.data,
          ),
        ),
      );
    }
  }

  Future<void> startCompressImagesIfNeed() async {
    for (final f in mediaFiles) {
      if (f is VMediaEditorImage && f.data.fileSource.filePath != null) {
        f.data.fileSource.filePath =
            (await _compressIoImage(f.data.fileSource.filePath!)).path;
      } else if (f is VMediaEditorImage && f.data.fileSource.bytes != null) {
        f.data.fileSource.bytes =
            await _compressJsImage(f.data.fileSource.bytes!);
      }
    }
    _updateScreen();
  }

  Future<void> onSubmitData(BuildContext context) async {
    isCompressing = true;
    _updateScreen();
    for (final f in mediaFiles) {
      if (f is VMediaEditorImage && f.data.isFromPath) {
        final data = await _getImageInfo(path: f.data.fileSource.filePath!);
        f.data.width = data.image.width;
        f.data.height = data.image.height;
      } else if (f is VMediaEditorImage && f.data.isFromBytes) {
        final data = await _getImageInfo(bytes: f.data.fileSource.bytes!);
        f.data.width = data.image.width;
        f.data.height = data.image.height;
      } else if (f is VMediaEditorVideo) {
        f.data.duration =
            await MediaEditorHelpers.getVideoDurationMill(f.data.fileSource);
      }
    }
    //await VideoCompress.deleteAllCache();
    Navigator.pop(context, mediaFiles);
  }

  Future<ImageInfo> _getImageInfo({List<int>? bytes, String? path}) {
    return MediaEditorHelpers.getImageInfo(bytes: bytes, path: path);
  }

  Future<String?> _ioImageCropper(String path) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      return croppedFile.path;
    }
    return null;
  }
}
