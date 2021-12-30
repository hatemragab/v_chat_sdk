import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../services/v_chat_app_service.dart';
import '../../../../../utils/custom_widgets/custom_alert_dialog.dart';
import '../../../../../utils/v_chat_config.dart';

class AttachmentPickerWidget extends StatelessWidget {
  const AttachmentPickerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final t = VChatAppService.instance.getTrans(ctx);
    return CupertinoActionSheet(
      cancelButton: CupertinoActionSheetAction(
        child: Text(VChatAppService.instance.getTrans(ctx).cancel()),
        onPressed: () {
          return Navigator.pop(ctx);
        },
      ),
      actions: [
        CupertinoActionSheetAction(
          child: Text(VChatAppService.instance.getTrans(ctx).photo()),
          onPressed: () async {
            final picker = ImagePicker();
            final pickedFile =
                await picker.pickImage(source: ImageSource.gallery);

            if (pickedFile != null) {
              if (File(pickedFile.path).lengthSync() >
                  VChatConfig.maxMessageFileSize) {
                File(pickedFile.path).deleteSync();
                CustomAlert.error(msg: t.fileIsTooBig());
                Navigator.pop(ctx);
              }
              return Navigator.pop(
                ctx,
                {"type": "photo", "path": pickedFile.path},
              );
            }
            Navigator.pop(ctx);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(t.file()),
          onPressed: () async {
            final FilePickerResult? result =
                await FilePicker.platform.pickFiles();
            if (result != null) {
              if (File(result.files.first.path!).lengthSync() >
                  VChatConfig.maxMessageFileSize) {
                File(result.files.first.path!).deleteSync();
                CustomAlert.error(msg: t.fileIsTooBig());
                return Navigator.pop(ctx);
              }
              return Navigator.pop(
                ctx,
                {"type": "file", "path": result.files.first.path},
              );
            }
            return Navigator.pop(ctx);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(t.video()),
          onPressed: () async {
            final FilePickerResult? result =
                await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['mp4', 'mkv', 'avi', 'm4p', 'flv'],
            );
            if (result != null) {
              if (File(result.files.first.path!).lengthSync() >
                  VChatConfig.maxMessageFileSize) {
                File(result.files.first.path!).deleteSync();
                CustomAlert.error(msg: t.fileIsTooBig());
                return Navigator.pop(ctx);
              }
              return Navigator.pop(
                ctx,
                {"type": "video", "path": result.files.first.path},
              );
            }
            return Navigator.pop(ctx);
          },
        ),
      ],
    );
  }
}
