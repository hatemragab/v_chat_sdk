// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:v_platform/v_platform.dart';

class DragDropIfWeb extends StatefulWidget {
  final Widget child;
  final Function(List<VPlatformFile> files) onDragDone;

  const DragDropIfWeb({
    super.key,
    required this.child,
    required this.onDragDone,
  });

  @override
  State<DragDropIfWeb> createState() => _DragDropIfWebState();
}

class _DragDropIfWebState extends State<DragDropIfWeb> {
  final controller = Completer<DropzoneViewController>();
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    if (VPlatforms.isWeb) {
      return RawKeyboardListener(
        focusNode: FocusNode(),
        // onKey: (x) async {
        //   // detect if ctrl + v or cmd + v is pressed
        //   if (x.isControlPressed && x.character == "v" ||
        //       x.isMetaPressed && x.character == "v") {
        //     // you need add some package "pasteboard" ,
        //     // if you wan to get image from clipboard, or just replace with some handle
        //     final imageBytes = await Pasteboard.image;
        //     if (imageBytes != null) {
        //       controller.onGetClipboardImageBytes(imageBytes);
        //     }
        //   }
        // },
        child: Stack(
          children: [
            DropzoneView(
              operation: DragOperation.copy,
              cursor: CursorType.grab,
              onCreated: (DropzoneViewController ctrl) {
                controller.complete(ctrl);
              },
              onError: (String? ev) {
                if (kDebugMode) {
                  print('Error: $ev');
                }
              },
              onHover: () {
                setState(() {
                  isHovering = true;
                });
              },
              onDrop: (dynamic file) async {},
              onDropMultiple: (List<dynamic>? files) async {
                isHovering = false;
                setState(() {});
                if (files == null) return;
                final controller = await this.controller.future;
                final draggedFiles = <VPlatformFile>[];
                for (final file in files) {
                  final fileBytes = await controller.getFileData(file);
                  final fileName = await controller.getFilename(file);
                  draggedFiles.add(VPlatformFile.fromBytes(
                    name: fileName,
                    bytes: fileBytes,
                  ));
                }
                widget.onDragDone(draggedFiles);
              },
              onLeave: () {
                isHovering = false;
                setState(() {});
              },
            ),
            widget.child,
            Container(
              color: isHovering ? Colors.blue.withOpacity(.5) : null,
            )
          ],
        ),
      );
    }
    return widget.child;
  }
}
