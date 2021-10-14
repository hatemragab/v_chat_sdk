import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/v_chat_message.dart';
import '../../../../services/vchat_app_service.dart';
import '../../../../utils/api_utils/server_config.dart';
import '../../../image_viewer/views/image_viewer_view.dart';

class MessageImageItem extends GetView {
  final VChatMessage _message;
  final bool isSender;
  final myId = VChatAppService.to.vChatUser!.id;

  MessageImageItem(this._message, {Key? key, required this.isSender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageViewerView(
                  ServerConfig.MESSAGES_BASE_URL +
                      _message.messageAttachment!.imageUrl.toString()),
            ));
      },
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500),
        height: double.parse(_message.messageAttachment!.height!),
        width: double.parse(_message.messageAttachment!.width!),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey,
        ),
        child: CachedNetworkImage(
          imageUrl: ServerConfig.MESSAGES_BASE_URL +
              _message.messageAttachment!.imageUrl.toString(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
