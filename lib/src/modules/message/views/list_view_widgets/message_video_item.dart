import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/src/models/v_chat_message.dart';
import 'package:v_chat_sdk/src/modules/video_player/views/video_player_view.dart';
import 'package:v_chat_sdk/src/utils/custom_widgets/rounded_container.dart';
import 'package:v_chat_sdk/src/utils/v_chat_config.dart';

class MessageVideoItem extends StatelessWidget {
  final VChatMessage _message;
  final bool isSender;

  const MessageVideoItem(this._message, {Key? key, required this.isSender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final att = _message.messageAttachment!;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerView(
              VChatConfig.messagesMediaBaseUrl + att.playUrl.toString(),
            ),
          ),
        );
      },
      child: Container(
        height: double.parse(att.height!),
        width: double.parse(att.width!),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black26
              : Colors.grey[300],
        ),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl:
                    VChatConfig.messagesMediaBaseUrl + att.imageUrl.toString(),
                fit: BoxFit.cover,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedContainer(
                  height: 60,
                  width: 60,
                  color: Colors.blueGrey.withOpacity(.9),
                  boxShape: BoxShape.circle,
                  child: const Icon(
                    Icons.play_arrow,
                    size: 60,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: RoundedContainer(
                borderRadius: BorderRadius.circular(30),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.blueGrey.withOpacity(.5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.videocam_rounded,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    att.fileDuration!.s2.color(Colors.white),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              left: 5,
              child: RoundedContainer(
                borderRadius: BorderRadius.circular(30),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.blueGrey.withOpacity(.5),
                child: att.fileSize!.s2.color(Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
