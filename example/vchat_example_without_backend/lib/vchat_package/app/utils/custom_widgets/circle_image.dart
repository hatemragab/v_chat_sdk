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
      double width = 69,
      double height = 70,
      bool isOnline = false,
      bool isGroup = false,
      bool isSelected = false}) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(1),
          child: Container(
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: ServerConfig.PROFILE_IMAGES_BASE_URL + path,
                fit: BoxFit.cover,
                width: width,
                height: height,
                errorWidget: (context, url, error) => Icon(Icons.error),
                placeholder: (context, url) =>
                    CircularProgressIndicator.adaptive(),
                alignment: Alignment.center,
                useOldImageOnUrlChange: true,
              ),
            ),
          ),
        ),
        if (isOnline || isGroup || isSelected)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.white, width: isGroup ? 0 : 1.5)),
              child: Icon(
                isGroup
                    ? Icons.home_sharp
                    : isOnline
                        ? Icons.circle
                        : Icons.done,
                color: isGroup ? Colors.red : Colors.green,
                size: 20,
              ),
            ),
          )
        else
          SizedBox.shrink()
      ],
    );
  }

}
