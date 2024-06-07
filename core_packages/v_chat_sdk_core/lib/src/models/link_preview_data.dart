// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/models/v_message/image_message/message_image_data.dart';

class VLinkPreviewData {
  final VMessageImageData? image;
  final String? title;
  final String? desc;
  final String? link;

  const VLinkPreviewData({
    this.image,
    this.title,
    this.desc,
    this.link,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image?.toMap(),
      'title': title,
      'desc': desc,
      'link': link,
    };
  }

  @override
  String toString() {
    return 'LinkPreviewData{image: $image, title: $title, desc: $desc, link: $link}';
  }

  factory VLinkPreviewData.fromMap(
    Map<String, dynamic> map,
  ) {
    return VLinkPreviewData(
      image: map['image'] == null
          ? null
          : VMessageImageData.fromMap(
              map['image'] as Map<String, dynamic>,
            ),
      title: map['title'] as String?,
      desc: map['desc'] as String?,
      link: map['link'] as String?,
    );
  }
}
