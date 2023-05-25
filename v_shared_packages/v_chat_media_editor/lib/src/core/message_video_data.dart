// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_platform/v_platform.dart';

import 'message_image_data.dart';

class MessageVideoData {
  VPlatformFile fileSource;
  MessageImageData? thumbImage;
  int? duration;

  Duration? get durationObj =>
      duration == null ? null : Duration(milliseconds: duration!);

  String? get durationFormat {
    if (durationObj == null) return null;
    return '$durationObj'.split('.')[0].padLeft(8, '0');
  }

//<editor-fold desc="Data Methods">

  MessageVideoData({
    required this.fileSource,
    this.thumbImage,
    required this.duration,
  });

  bool get isFromPath => fileSource.fileLocalPath != null;

  bool get isFromBytes => fileSource.bytes != null;

  @override
  String toString() {
    return 'MessageVideoData{fileSource: $fileSource, thumbImageSource: $thumbImage, duration: $duration}';
  }

  Map<String, dynamic> toMap() {
    return {
      ...fileSource.toMap(),
      'duration': duration,
      'thumbImage': thumbImage == null ? null : thumbImage!.toMap(),
    };
  }

  factory MessageVideoData.fromMap(
    Map<String, dynamic> map, {
    String? baseUrl,
  }) {
    return MessageVideoData(
      fileSource: VPlatformFile.fromMap(map: map, baseUrl: baseUrl),
      duration: map['duration'] as int?,
      thumbImage: map['thumbImage'] == null
          ? null
          : MessageImageData.fromMap(
              map['thumbImage'] as Map<String, dynamic>,
              baseUrl: baseUrl,
            ),
    );
  }

//</editor-fold>
}
