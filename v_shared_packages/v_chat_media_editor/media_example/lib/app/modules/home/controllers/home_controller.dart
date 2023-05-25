// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_media_editor/v_chat_media_editor.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class HomeController extends GetxController {
  final files = <VPlatformFile>[].obs;
  final proccessedData = <VBaseMediaRes>[].obs;

  void onGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      //type: FileType.media,
    );

    if (result != null) {
      final mediaFiles = <VPlatformFile>[];
      if (kIsWeb) {
        for (final f in result.files) {
          mediaFiles.add(
            VPlatformFile.fromBytes(name: f.name, bytes: f.bytes!),
          );
        }
      } else {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        for (var e in files) {
          mediaFiles.add(
            VPlatformFile.fromPath(filePath: e.path),
          );
        }
      }
      final editedFiles = await Navigator.of(Get.context!).push(
        MaterialPageRoute(
          builder: ((context) => VMediaEditorView(files: mediaFiles)),
        ),
      ) as List<VBaseMediaRes>?;
      if (editedFiles == null) {
        return;
      }

      proccessedData.clear();
      proccessedData.addAll(editedFiles);
      for (final f in editedFiles) {
        print(f.toString());
        if (f is VMediaImageRes) {
          files.add(f.data.fileSource);
        } else if (f is VMediaVideoRes) {
          files.add(f.data.fileSource);
        }
      }
    } else {
      // User canceled the picker
    }
  }
}
