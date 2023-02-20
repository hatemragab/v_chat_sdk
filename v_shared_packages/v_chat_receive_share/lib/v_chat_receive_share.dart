// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

library v_chat_receive_share;

import 'package:flutter/foundation.dart';
import 'package:share_handler/share_handler.dart';
import 'package:v_chat_media_editor/v_chat_media_editor.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

Future<void> vInitReceiveShareHandler() async {
  if (!VPlatforms.isMobile) return;

  final handler = ShareHandlerPlatform.instance;
  final SharedMedia? media = await handler.getInitialSharedMedia();
  if (media != null) {
    _handleOnNewShare(media);
  }
  handler.sharedMediaStream.listen(
    (SharedMedia media) async {
      _handleOnNewShare(media);
    },
  );
}

Future<void> _handleOnNewShare(SharedMedia media) async {
  final messages = <VBaseMessage>[];
  final pFiles = <VPlatformFileSource>[];

  if (media.attachments != null && media.attachments!.isNotEmpty) {
    for (final m in media.attachments!) {
      if (m == null) continue;
      m.path.replaceAll("file://", "");
      pFiles.add(
        VPlatformFileSource.fromPath(
          filePath: m.path,
        ),
      );
    }
    final context = VChatController.I.navigationContext;
    final roomsIds = await VChatController.I.vNavigator.roomNavigator
        .toForwardPage(context, null);
    if (roomsIds != null) {
      final fileRes = await context.toPage(VMediaEditorView(
        files: pFiles,
      )) as List<VBaseMediaRes>?;
      if (fileRes == null) return;
      for (final id in roomsIds) {
        messages.addAll(fileRes
            .map((e) => VFileMessage.buildMessage(
                  roomId: id,
                  data: VMessageFileData(fileSource: e.getVPlatformFile()),
                  isEncrypted: false,
                ))
            .toList());
      }

      if (messages.isNotEmpty) {
        for (final message in messages) {
          await VChatController.I.nativeApi.local.message
              .insertMessage(message);
          try {
            MessageUploaderQueue.instance.addToQueue(
              await MessageFactory.createUploadMessage(message),
            );
          } catch (err) {
            if (kDebugMode) {
              print(err);
            }
          }
        }
      }
    }
  }
}
