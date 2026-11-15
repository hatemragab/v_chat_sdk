// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:v_platform/v_platform.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

abstract class VAppPick {
  static bool isPicking = false;

  static const _defaultAspectRatioPresets = <CropAspectRatioPresetData>[
    CropAspectRatioPreset.square,
    CropAspectRatioPreset.ratio3x2,
    CropAspectRatioPreset.original,
    CropAspectRatioPreset.ratio4x3,
    CropAspectRatioPreset.ratio16x9,
  ];

  static Future<VPlatformFile?> _toVPlatformFile(PlatformFile file) async {
    if (file.path case final path?) {
      return VPlatformFile.fromPath(fileLocalPath: path);
    }
    final bytes = await file.readAsBytes();
    return VPlatformFile.fromBytes(name: file.name, bytes: bytes);
  }

  static Future<T> _whilePicking<T>(Future<T> Function() action) async {
    isPicking = true;
    try {
      return await action();
    } finally {
      isPicking = false;
    }
  }

  static Future<VPlatformFile?> getCroppedImage({
    bool isFromCamera = false,
  }) async {
    final img = await getImage(isFromCamera: isFromCamera);
    if (img != null) {
      if (VPlatforms.isMobile) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: img.fileLocalPath!,
          compressQuality: 70,
          compressFormat: ImageCompressFormat.png,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop It',
              toolbarColor: Colors.white,
              toolbarWidgetColor: Colors.black,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              cropStyle: CropStyle.circle,
              aspectRatioPresets: _defaultAspectRatioPresets,
            ),
            IOSUiSettings(
              title: 'Crop It',
              cropStyle: CropStyle.circle,
              aspectRatioPresets: _defaultAspectRatioPresets,
            ),
          ],
        );

        if (croppedFile == null) {
          return null;
        }
        return VPlatformFile.fromPath(fileLocalPath: croppedFile.path);
      }
      return img;
    }
    return null;
  }

  static Future<VPlatformFile?> getImage({bool isFromCamera = false}) async {
    final pickedFile = await _whilePicking(
      () => FilePicker.pickFile(type: FileType.image),
    );
    return pickedFile == null ? null : await _toVPlatformFile(pickedFile);
  }

  static Future<List<VPlatformFile>?> getImages() async {
    final pickedFiles = await _whilePicking(
      () => FilePicker.pickFiles(type: FileType.image),
    );
    final files = await Future.wait(pickedFiles.map(_toVPlatformFile));
    final validFiles = files.whereType<VPlatformFile>().toList();
    return validFiles.isEmpty ? null : validFiles;
  }

  static Future<List<VPlatformFile>?> getMedia() async {
    final pickedFiles = await _whilePicking(
      () => FilePicker.pickFiles(type: FileType.media),
    );
    final files = await Future.wait(pickedFiles.map(_toVPlatformFile));
    final validFiles = files.whereType<VPlatformFile>().toList();
    return validFiles.isEmpty ? null : validFiles;
  }

  static Future<VPlatformFile?> getVideo() async {
    final pickedFile = await _whilePicking(
      () => FilePicker.pickFile(type: FileType.video),
    );
    return pickedFile == null ? null : await _toVPlatformFile(pickedFile);
  }

  static Future<List<VPlatformFile>?> getFiles() async {
    final pickedFiles = await _whilePicking(FilePicker.pickFiles);
    final files = await Future.wait(pickedFiles.map(_toVPlatformFile));
    final validFiles = files.whereType<VPlatformFile>().toList();
    return validFiles.isEmpty ? null : validFiles;
  }

  static Future<VPlatformFile?> pickFromWeAssetCamera({
    XFileCapturedCallback? onXFileCaptured,
    required BuildContext context,
    int videoSeconds = 45,
  }) async {
    final AssetEntity? entity = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: CameraPickerConfig(
        enableRecording: true,
        enableTapRecording: true,
        maximumRecordingDuration: Duration(seconds: videoSeconds),
        textDelegate: const EnglishCameraPickerTextDelegate(),
        onXFileCaptured: onXFileCaptured,
        shouldAutoPreviewVideo: true,
      ),
    );
    if (entity == null) {
      return null;
    }
    final f = (await entity.file)!;
    return VPlatformFile.fromPath(fileLocalPath: f.path);
  }

  static Future clearPickerCache() async {
    await FilePicker.clearTemporaryFiles();
  }

  static Future<VPlatformFile?> croppedImage({
    required VPlatformFile file,
    List<CropAspectRatioPresetData>? aspectRatioPresets,
  }) async {
    if (!file.isContentImage) return null;
    final presets = aspectRatioPresets ?? _defaultAspectRatioPresets;
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.fileLocalPath!,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: presets,
        ),
        IOSUiSettings(title: 'Cropper', aspectRatioPresets: presets),
      ],
    );
    if (croppedFile != null) {
      return VPlatformFile.fromPath(fileLocalPath: croppedFile.path);
    }
    return null;
  }
}
