// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../shared/constraint_image.dart';
import '../shared/rounded_container.dart';

class VideoMessageItem extends StatelessWidget {
  final VVideoMessage message;

  const VideoMessageItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 350,
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        //  fit: StackFit.expand,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              getBackground(context),
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
              borderRadius: BorderRadius.circular(5),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.blueGrey.withOpacity(.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  message.data.durationFormat == null
                      ? const SizedBox.shrink()
                      : Row(
                          children: [
                            const Icon(
                              Icons.videocam_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            message.data.durationFormat!.cap
                                .color(Colors.white),
                          ],
                        ),
                  Row(
                    children: [
                      const Icon(
                        Icons.photo_size_select_actual_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      message.data.fileSource.readableSize.cap
                          .color(Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getBackground(BuildContext context) {
    if (message.data.thumbImage == null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black,
        ),
      );
    }
    return VConstraintImage(
      data: message.data.thumbImage!,
      borderRadius: BorderRadius.circular(15),
      fit: BoxFit.contain,
    );
  }
}
