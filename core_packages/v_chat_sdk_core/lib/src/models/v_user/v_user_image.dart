// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class VUserImage {
  final String fullImage;
  final String chatImage;
  final String smallImage;

//<editor-fold desc="Data Methods">

  const VUserImage({
    required this.fullImage,
    required this.chatImage,
    required this.smallImage,
  });

  VUserImage.fromSingleUrl(String url)
      : fullImage = url,
        chatImage = url,
        smallImage = url;

  VUserImage.fromFakeSingleUrl()
      : fullImage = "https://picsum.photos/300/300",
        chatImage = "https://picsum.photos/300/300",
        smallImage = "https://picsum.photos/300/300";

  @override
  String toString() {
    return 'UserImage{'
        ' fullImage: $fullImage,'
        ' chatImage: $chatImage,'
        ' smallImage: $smallImage, '
        '}';
  }

  Map<String, dynamic> toMap() {
    return {
      'fullImage': fullImage,
      'chatImage': chatImage,
      'smallImage': smallImage,
    };
  }

  factory VUserImage.fromMap(Map<String, dynamic> map) {
    return VUserImage(
      fullImage: map['fullImage'] as String,
      chatImage: map['chatImage'] as String,
      smallImage: map['smallImage'] as String,
    );
  }

//</editor-fold>
}
