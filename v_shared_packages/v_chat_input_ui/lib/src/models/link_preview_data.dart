// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'message_image_data.dart';

class LinkPreviewData {
  final VMessageImageData? image;
  final String? title;
  final String? desc;
  final String? link;

  const LinkPreviewData({
    this.image,
    this.title,
    this.desc,
    this.link,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image == null ? null : image!.toMap(),
      'title': title,
      'desc': desc,
      'link': link,
    };
  }

  @override
  String toString() {
    return 'LinkPreviewData{image: $image, title: $title, desc: $desc, link: $link}';
  }

  factory LinkPreviewData.fromMap(
    Map<String, dynamic> map, {
    String? baseUrl,
  }) {
    return LinkPreviewData(
      image: map['image'] == null
          ? null
          : VMessageImageData.fromMap(
              map['image'] as Map<String, dynamic>,
              baseUrl: baseUrl,
            ),
      title: map['title'] as String?,
      desc: map['desc'] as String?,
      link: map['link'] as String?,
    );
  }
}
