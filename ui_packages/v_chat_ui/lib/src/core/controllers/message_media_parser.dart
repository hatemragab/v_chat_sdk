import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../media_editor/src/core/core.dart';
import '../../media_editor/src/modules/home/media_editor_view.dart';

class MessageMediaParser {
  Future<List<VBaseMessage>> parseMedia(List<PlatformFileSource> platformFiles,
      List<String> roomIds, BuildContext context) async {
    final res = <VBaseMessage>[];
    final toEdit = <PlatformFileSource>[];
    for (final file in platformFiles) {
      switch (file.getMediaType) {
        case SupportedFilesType.image:
          toEdit.add(
            file,
          );
          break;
        case SupportedFilesType.video:
          toEdit.add(
            file,
          );
          break;
        case SupportedFilesType.file:
          res.add(_buildFileFromFile(VMessageFileData(fileSource: file)));
          break;
      }
    }

    final editedFiles = <VBaseMessage>[];
    if (toEdit.isNotEmpty) {
      editedFiles.addAll(await _goToEditFiles(toEdit, context));
      if (editedFiles.isEmpty) return <VBaseMessage>[];
    }

    for (final id in roomIds) {
      for (final file in editedFiles) {
        // build message for each room!
        if (file is VImageMessage) {
          res.add(
            VImageMessage.buildMessage(
              roomId: id,
              fileSource: file.fileSource,
            ),
          );
        } else if (file is VVideoMessage) {
          res.add(
            VVideoMessage.buildMessage(
              roomId: id,
              fileSource: file.fileSource,
            ),
          );
        } else if (file is VFileMessage) {
          res.add(
            VFileMessage.buildMessage(
              roomId: id,
              fileSource: file.fileSource,
            ),
          );
        }
      }
      for (final i in res) {
        i.roomId = id;
      }
    }
    return res;
  }

  Future<List<VBaseMessage>> _goToEditFiles(
      List<PlatformFileSource> toEdit, BuildContext context) async {
    final res = <VBaseMessage>[];
    final editedFiles = await context.toPage(MediaEditorView(
      files: toEdit,
    )) as List<BaseMediaEditor>?;
    if (editedFiles == null) {
      return <VBaseMessage>[];
    }
    for (final editedFile in editedFiles) {
      if (editedFile is MediaEditorImage) {
        final x = await _buildImageFromFile(editedFile);
        res.add(x);
      } else if (editedFile is MediaEditorVideo) {
        res.add(await _buildVideoFromFile(editedFile));
      }
    }
    return res;
  }

  Future<VBaseMessage> _buildImageFromFile(MediaEditorImage file) async {
    return VImageMessage.buildMessage(
      roomId: "roomId must set later! ",
      fileSource: file.data,
    );
  }

  VBaseMessage _buildFileFromFile(VMessageFileData file) {
    return VFileMessage.buildMessage(
      roomId: "roomId must set later! ",
      fileSource: file,
    );
  }

  Future<VBaseMessage> _buildVideoFromFile(MediaEditorVideo file) async {
    return VVideoMessage.buildMessage(
      roomId: "roomId must set later!",
      fileSource: file.data,
    );
  }
}
