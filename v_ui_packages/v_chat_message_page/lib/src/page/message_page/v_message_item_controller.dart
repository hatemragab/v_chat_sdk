import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../core/enums.dart';
import '../../core/v_downloader_service.dart';
import 'message_provider.dart';

//todo trans
class VMessageItemController {
  final MessageProvider _messageProvider;
  final BuildContext context;
  final _localStorage = VChatController.I.nativeApi.local;

  VMessageItemController(this._messageProvider, this.context);

  ModelSheetItem<VMessageItemClickRes> _deleteItem() {
    return ModelSheetItem(
      id: VMessageItemClickRes.delete,
      title: "Delete",
      iconData: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
    );
  }

  ModelSheetItem<VMessageItemClickRes> _copyItem() {
    return ModelSheetItem(
        id: VMessageItemClickRes.copy,
        title: "Copy",
        iconData: const Icon(Icons.copy));
  }

  ModelSheetItem<VMessageItemClickRes> _infoItem() {
    return ModelSheetItem(
      id: VMessageItemClickRes.info,
      title: "Info",
      iconData: const Icon(Icons.info),
    );
  }

  ModelSheetItem<VMessageItemClickRes> _shareItem() {
    return ModelSheetItem(
      id: VMessageItemClickRes.share,
      title: "Share",
      iconData: const Icon(Icons.share),
    );
  }

  ModelSheetItem<VMessageItemClickRes> _forwardItem() {
    return ModelSheetItem(
      id: VMessageItemClickRes.forward,
      title: "Forward",
      iconData: const Icon(Icons.forward),
    );
  }

  ModelSheetItem<VMessageItemClickRes> _replyItem() {
    return ModelSheetItem(
      id: VMessageItemClickRes.reply,
      title: "Reply",
      iconData: const Icon(Icons.replay),
    );
  }

  void onMessageItemPress(VBaseMessage message) async {
    if (message is VImageMessage) {
      context.toPage(VImageViewer(
        platformFileSource: message.data.fileSource,
        appName: VAppConstants.appName,
        //todo trans
        successfullyDownloaded: "successfully Downloaded",
      ));
    }
    if (message is VFileMessage) {
      VDownloaderService.instance.addToQueue(message);
    }
  }

  void onMessageItemLongPress(
    VBaseMessage message,
    VRoom room,
    Function(VBaseMessage p1) onSwipe,
  ) async {
    FocusScope.of(context).unfocus();
    final items = <ModelSheetItem<VMessageItemClickRes>>[];
    if (message.emitStatus.isServerConfirm) {
      items.add(_forwardItem());
      items.add(_replyItem());
      items.add(_shareItem());
      if (message.isMeSender) {
        items.add(_infoItem());
      }
    }
    items.add(
      _deleteItem(),
    );
    if (message.messageType.isText) {
      items.add(_copyItem());
    }

    if (message.messageType.isAllDeleted) {
      items.clear();
      //solution
      items.add(_deleteItem());
    }

    final res = await VAppAlert.showModalSheet(
      content: items,
      context: context,
    );
    if (res == null) return;
    switch (res.id as VMessageItemClickRes) {
      case VMessageItemClickRes.forward:
        _handleForward(message);
        break;
      case VMessageItemClickRes.reply:
        onSwipe(message);
        break;
      case VMessageItemClickRes.share:
        _handleShare(message);
        break;
      case VMessageItemClickRes.info:
        _handleInfo(message, room);
        break;
      case VMessageItemClickRes.delete:
        _handleDelete(message);
        break;
      case VMessageItemClickRes.copy:
        _handleCopy(message);
        break;
    }
  }

  void _handleForward(VBaseMessage baseMessage) async {
    final ids = await VChatController.I.vNavigator.roomNavigator
        .toForwardPage(context, baseMessage.roomId);
    if (ids != null) {
      for (final roomId in ids) {
        VBaseMessage? message;
        switch (baseMessage.messageType) {
          case MessageType.text:
            message = VTextMessage.buildMessage(
              content: baseMessage.realContent,
              roomId: roomId,
              forwardId: baseMessage.localId,
              isEncrypted: baseMessage.isEncrypted,
            );
            break;
          case MessageType.image:
            message = VImageMessage.buildMessage(
              data: (baseMessage as VImageMessage).data,
              roomId: roomId,
              forwardId: baseMessage.localId,
            );
            break;
          case MessageType.file:
            message = VFileMessage.buildMessage(
              data: (baseMessage as VFileMessage).data,
              isEncrypted: false,
              roomId: roomId,
              forwardId: baseMessage.localId,
            );
            break;
          case MessageType.video:
            message = VVideoMessage.buildMessage(
              data: (baseMessage as VVideoMessage).data,
              roomId: roomId,
              forwardId: baseMessage.localId,
            );
            break;
          case MessageType.voice:
            message = VVoiceMessage.buildMessage(
              data: (baseMessage as VVoiceMessage).data,
              roomId: roomId,
              forwardId: baseMessage.localId,
            );
            break;
          case MessageType.location:
            message = VLocationMessage.buildMessage(
              data: (baseMessage as VLocationMessage).data,
              roomId: roomId,
              forwardId: baseMessage.localId,
            );
            break;
          case MessageType.allDeleted:
            break;
          case MessageType.call:
            break;
          case MessageType.custom:
            message = VCustomMessage.buildMessage(
              data: (baseMessage as VCustomMessage).data,
              content: baseMessage.realContent,
              isEncrypted: baseMessage.isEncrypted,
              roomId: roomId,
              forwardId: baseMessage.localId,
            );
            break;
          case MessageType.info:
            break;
        }
        if (message != null) {
          await _localStorage.message.insertMessage(message);
          MessageUploaderQueue.instance.addToQueue(
            await MessageFactory.createForwardUploadMessage(message),
          );
        }
      }
    }
  }

  void _handleShare(VBaseMessage message) async {
    if (message.emitStatus.isServerConfirm) {
      if (message is VTextMessage) {
        await Share.share(message.realContent);
        return;
      }
      if (message is VLocationMessage) {
        await Share.share(message.data.linkPreviewData.link.toString());
        return;
      }
      late final VPlatformFileSource pFile;
      if (message is VImageMessage) {
        pFile = message.data.fileSource;
      } else if (message is VVoiceMessage) {
        pFile = message.data.fileSource;
      } else if (message is VFileMessage) {
        pFile = message.data.fileSource;
      } else if (message is VVideoMessage) {
        pFile = message.data.fileSource;
      }
      final file = await DefaultCacheManager().getSingleFile(
        pFile.url!,
      );
      await Share.shareXFiles([XFile(file.path)]);
    }
  }

  void _handleInfo(VBaseMessage message, VRoom room) {
    FocusScope.of(context).unfocus();
    VChatController.I.vNavigator.messageNavigator.toMessageInfo(
      context,
      room,
      message,
    );
  }

  void _handleDelete(VBaseMessage message) async {
    final l = <ModelSheetItem>[];
    if (message.isMeSender &&
        !message.messageType.isAllDeleted &&
        message.emitStatus.isServerConfirm) {
      l.add(ModelSheetItem(title: 'Delete from all', id: 1));
    }
    l.add(ModelSheetItem(title: 'Delete from me', id: 2));
    final res = await VAppAlert.showModalSheet(
      content: l,
      context: context,
    );
    if (res == null) return;
    if (res.id == 1) {
      await vSafeApiCall(
        request: () async {
          return _messageProvider.deleteMessageFromAll(
            message.roomId,
            message.id,
          );
        },
        onSuccess: (response) {},
      );
    }
    if (res.id == 2) {
      await vSafeApiCall(
        request: () async {
          return _messageProvider.deleteMessageFromMe(message);
        },
        onSuccess: (response) {},
      );
    }
  }

  void _handleCopy(VBaseMessage message) async {
    //todo fix get real time if there mention
    await Clipboard.setData(
      ClipboardData(
        text: message.getMessageText,
      ),
    );
  }
}
