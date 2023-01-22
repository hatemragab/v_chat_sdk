import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../../v_chat_utils.dart';

abstract class VAppPick {
  static bool isPicking = false;

  static Future<VPlatformFileSource?> getCroppedImage(
      {bool isFromCamera = false}) async {
    final img = await getImage(isFromCamera: isFromCamera);
    if (img != null) {
      if (VPlatforms.isMobile) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: img.filePath!,
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
        return VPlatformFileSource.fromPath(filePath: croppedFile.path);
      }
      return img;
    }
    return null;
  }

  static Future<VPlatformFileSource?> getImage({
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
      return VPlatformFileSource.fromBytes(name: file.name, bytes: file.bytes!);
    }
    return VPlatformFileSource.fromPath(filePath: file.path!);
  }

  static Future<List<VPlatformFileSource>?> getImages() async {
    isPicking = true;
    final FilePickerResult? pickedFile = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: true);
    isPicking = false;
    if (pickedFile == null) return null;
    return pickedFile.files.map((e) {
      if (e.bytes != null) {
        return VPlatformFileSource.fromBytes(
          name: e.name,
          bytes: e.bytes!,
        );
      }
      return VPlatformFileSource.fromPath(filePath: e.path!);
    }).toList();
  }

  static Future<List<VPlatformFileSource>?> getMedia() async {
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
        return VPlatformFileSource.fromBytes(
          name: e.name,
          bytes: e.bytes!,
        );
      }
      return VPlatformFileSource.fromPath(filePath: e.path!);
    }).toList();
  }

  static Future<VPlatformFileSource?> getVideo() async {
    isPicking = true;
    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    isPicking = false;
    if (pickedFile == null) return null;
    final e = pickedFile.files.first;
    if (e.bytes != null) {
      return VPlatformFileSource.fromBytes(
        name: e.name,
        bytes: e.bytes!,
      );
    }
    return VPlatformFileSource.fromPath(filePath: e.path!);
  }

  static Future<List<VPlatformFileSource>?> getFiles() async {
    isPicking = true;
    final FilePickerResult? xFiles = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    isPicking = false;
    if (xFiles == null) return null;
    if (xFiles.files.isEmpty) return null;
    return xFiles.files.map((e) {
      if (e.bytes != null) {
        return VPlatformFileSource.fromBytes(
          name: e.name,
          bytes: e.bytes!,
        );
      }
      return VPlatformFileSource.fromPath(filePath: e.path!);
    }).toList();
  }

  static Future<VPlatformFileSource?> pickFromWeAssetCamera({
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
    return VPlatformFileSource.fromPath(filePath: f.path);
  }

  static Future clearPickerCache() async {
    await FilePicker.platform.clearTemporaryFiles();
  }

  static Future<VPlatformFileSource?> croppedImage({
    required VPlatformFileSource file,
    List<CropAspectRatioPreset>? aspectRatioPresets,
  }) async {
    if (!file.isContentImage) return null;
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.filePath!,
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
      return VPlatformFileSource.fromPath(
        filePath: croppedFile.path,
      );
    }
    return null;
  }
}
