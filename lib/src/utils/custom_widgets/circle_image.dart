import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../api_utils/server_config.dart';

class CircleImage {
  CircleImage._();

  static Widget file({required String filePath}) {
    return Image.file(
      File(filePath),
      fit: BoxFit.cover,
    );
  }

  static Widget network(
      {required String path,
      int radius = 30,
      bool isOnline = false,
      bool isGroup = false,
      bool isSelected = false}) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: CircleAvatar(
            radius: double.parse(radius.toString()),
            backgroundImage: CachedNetworkImageProvider(
              ServerConfig.profileImageBaseUrl + path,
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
        if (isOnline || isGroup || isSelected)
          Positioned(
            bottom: 5,
            right: 2,
            child: Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                  border: Border.all(
                      color: Colors.green, width: isGroup ? 0 : 0)),
              child: Icon(
                isGroup
                    ? Icons.home_sharp
                    : isOnline
                        ? Icons.circle
                        : Icons.done,
                color: isGroup ? Colors.red : Colors.green,
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
