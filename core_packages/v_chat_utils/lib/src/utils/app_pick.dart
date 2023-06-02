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

  static Future<VPlatformFile?> getCroppedImage({
    bool isFromCamera = false,
  }) async {
    final img = await getImage(isFromCamera: isFromCamera);
    if (img != null) {
      if (VPlatforms.isMobile) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: img.fileLocalPath!,
          compressQuality: 70,
          cropStyle: CropStyle.circle,
          compressFormat: ImageCompressFormat.png,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop It',
              toolbarColor: Colors.white,
              toolbarWidgetColor: Colors.black,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: 'Crop It',
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

  static Future<VPlatformFile?> getImage({
    bool isFromCamera = false,
  }) async {
    isPicking = true;
    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    isPicking = false;
    if (pickedFile == null) return null;
    final file = pickedFile.files.first;
    if (file.bytes != null) {
      return VPlatformFile.fromBytes(name: file.name, bytes: file.bytes!);
    }
    return VPlatformFile.fromPath(fileLocalPath: file.path!);
  }

  static Future<List<VPlatformFile>?> getImages() async {
    isPicking = true;
    final FilePickerResult? pickedFile = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: true);
    isPicking = false;
    if (pickedFile == null) return null;
    return pickedFile.files.map((e) {
      if (e.bytes != null) {
        return VPlatformFile.fromBytes(
          name: e.name,
          bytes: e.bytes!,
        );
      }
      return VPlatformFile.fromPath(fileLocalPath: e.path!);
    }).toList();
  }

  static Future<List<VPlatformFile>?> getMedia() async {
    isPicking = true;
    final xFiles = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: true,
    );
    isPicking = false;
    if (xFiles == null) return null;
    if (xFiles.files.isEmpty) return null;
    return xFiles.files.map((e) {
      if (e.bytes != null) {
        return VPlatformFile.fromBytes(
          name: e.name,
          bytes: e.bytes!,
        );
      }
      return VPlatformFile.fromPath(fileLocalPath: e.path!);
    }).toList();
  }

  static Future<VPlatformFile?> getVideo() async {
    isPicking = true;
    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    isPicking = false;
    if (pickedFile == null) return null;
    final e = pickedFile.files.first;
    if (e.bytes != null) {
      return VPlatformFile.fromBytes(
        name: e.name,
        bytes: e.bytes!,
      );
    }
    return VPlatformFile.fromPath(fileLocalPath: e.path!);
  }

  static Future<List<VPlatformFile>?> getFiles() async {
    isPicking = true;
    final FilePickerResult? xFiles = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    isPicking = false;
    if (xFiles == null) return null;
    if (xFiles.files.isEmpty) return null;
    return xFiles.files.map((e) {
      if (e.bytes != null) {
        return VPlatformFile.fromBytes(
          name: e.name,
          bytes: e.bytes!,
        );
      }
      return VPlatformFile.fromPath(fileLocalPath: e.path!);
    }).toList();
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
    await FilePicker.platform.clearTemporaryFiles();
  }

  static Future<VPlatformFile?> croppedImage({
    required VPlatformFile file,
    List<CropAspectRatioPreset>? aspectRatioPresets,
  }) async {
    if (!file.isContentImage) return null;
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.fileLocalPath!,
      aspectRatioPresets: aspectRatioPresets ??
          [
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
      return VPlatformFile.fromPath(
        fileLocalPath: croppedFile.path,
      );
    }
    return null;
  }
}
