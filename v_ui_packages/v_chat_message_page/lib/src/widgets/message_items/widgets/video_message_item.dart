import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../shared/rounded_container.dart';

class VideoMessageItem extends StatelessWidget {
  final VVideoMessage message;

  const VideoMessageItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        getBackground(context),
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
                message.data.dateFormat.s2.color(Colors.white),
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
            child: message.data.fileSource.readableSize.s2.color(Colors.white),
          ),
        )
      ],
    );
  }

  Widget getBackground(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    if (message.data.thumbImage == null) {
      return Container(
        color: Colors.black,
        height: 400,
        width: VPlatforms.isWeb ? 400 : 1000,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        constraints: BoxConstraints(
          maxHeight: VPlatforms.isMobile ? height * .50 : height * .30,
          maxWidth: VPlatforms.isMobile ? width * .80 : width * .40,
        ),
      );
    }
    return VPlatformCacheImageWidget(
      source: message.data.thumbImage!.fileSource,
      borderRadius: BorderRadius.circular(15),
      fit: BoxFit.cover,
      size: const Size(400, 400),
    );
  }
}
