import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../v_chat_config.dart';

class CircleImage {
  CircleImage._();

  static Widget file({required String filePath}) {
    return Image.file(
      File(filePath),
      fit: BoxFit.cover,
    );
  }

  static Widget network({
    required String path,
    int radius = 30,
    bool isOnline = false,
    bool isGroup = false,
    bool withSetting = false,
  }) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: CircleAvatar(
            radius: double.parse(radius.toString()),
            backgroundImage: CachedNetworkImageProvider(
              VChatConfig.profileImageBaseUrl + path,
            ),
            backgroundColor: Colors.transparent,
          ),
        ),
        // imageUrl: ServerConfig.PROFILE_IMAGES_BASE_URL + path,
        // fit: BoxFit.cover,
        // width: width,
        // height: height,
        // errorWidget: (context, url, error) => const Icon(Icons.error),
        // placeholder: (context, url) =>
        // const CircularProgressIndicator.adaptive(),
        // alignment: Alignment.center,
        // useOldImageOnUrlChange: true,
        if (withSetting)
          Positioned(
            bottom: 5,
            right: 2,
            child: Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isGroup ? Colors.grey : Colors.green,
                border: Border.all(color: Colors.green, width: isGroup ? 0 : 0),
              ),
              child: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 18,
              ),
            ),
          )
        else if (isOnline || isGroup)
          Positioned(
            bottom: 5,
            right: 2,
            child: Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isGroup ? Colors.grey : Colors.green,
                border: Border.all(
                  color: Colors.green,
                  width: isGroup ? 0 : 0,
                ),
              ),
              child: isGroup
                  ? const Icon(
                      Icons.group,
                      size: 18,
                    )
                  : const Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 18,
                    ),
            ),
          )
        else
          const SizedBox.shrink()
      ],
    );
  }
}
