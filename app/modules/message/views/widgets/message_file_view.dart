import 'package:flutter/material.dart';

import 'package:textless/textless.dart';
import '../../../../models/vchat_message.dart';

import '../../../../services/vchat_app_service.dart';
import '../../../../utils/custom_widgets/rounded_container.dart';
import '../../../../utils/file_utils.dart';


class MessageFileView extends StatelessWidget {
  final VchatMessage _message;
  final bool isSender;
  final myId = VChatAppService.to.vChatUser!.id;

  MessageFileView(this._message, {required this.isSender});

  @override
  Widget build(BuildContext context) {
    final att = _message.messageAttachment!;

    return InkWell(
      onTap: () {
        FileUtils.newDownloadFile(context,att);
      },
      child: RoundedContainer(
        height: 75,
        borderRadius: BorderRadius.circular(30),
        child: Row(
          children: [
            const SizedBox(
              width: 25,
            ),
            Icon(
              Icons.insert_drive_file,
              size: 50,
              color: Colors.blueGrey,
            ),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  att.linkTitle.toString().s2.size(13.4).overflowEllipsis,
                  _message.messageAttachment!.fileSize!.s2.size(14)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
