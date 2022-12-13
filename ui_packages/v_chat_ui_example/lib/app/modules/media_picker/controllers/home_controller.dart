import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class HomeController extends GetxController {
  final files = <PlatformFileSource>[].obs;

  void onGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.media,
    );

    if (result != null) {
      final mediaFiles = <PlatformFileSource>[];
      if (kIsWeb) {
        for (final f in result.files) {
          mediaFiles.add(
            PlatformFileSource.fromBytes(name: f.name, bytes: f.bytes!),
          );
        }
      } else {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        for (var e in files) {
          mediaFiles.add(
            PlatformFileSource.fromPath(filePath: e.path),
          );
        }
      }
      // final editedFiles = await Navigator.of(Get.context!).push(
      //   MaterialPageRoute(
      //     builder: ((context) => MediaEditorView(files: mediaFiles)),
      //   ),
      // ) as List<BaseMediaEditor>?;
      // if (editedFiles == null) {
      //   return;
      // }
      // for (final f in editedFiles) {
      //   print(f.toString());
      //   // if (f is MediaEditorImage) {
      //   //   files.add(f.data.fileSource);
      //   // } else if (f is MediaEditorVideo) {
      //   //   files.add(f.data.fileSource);
      //   // }
      // }
    } else {
      // User canceled the picker
    }
  }
}
