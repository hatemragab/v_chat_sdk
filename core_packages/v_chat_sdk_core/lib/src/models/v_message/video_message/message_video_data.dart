// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_platform/v_platform.dart';

import '../image_message/message_image_data.dart';

class VMessageVideoData {
  VPlatformFile fileSource;
  VMessageImageData? thumbImage;
  int? duration;

  Duration? get durationObj =>
      duration == null ? null : Duration(milliseconds: duration!);

  String? get durationFormat {
    if (durationObj == null) return null;
    return '$durationObj'.split('.')[0].padLeft(8, '0');
  }

//<editor-fold desc="Data Methods">

  VMessageVideoData({
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

  factory VMessageVideoData.fromMap(
    Map<String, dynamic> map, {
    String? baseUrl,
  }) {
    return VMessageVideoData(
      fileSource: VPlatformFile.fromMap(map: map, baseUrl: baseUrl),
      duration: map['duration'] as int?,
      thumbImage: map['thumbImage'] == null
          ? null
          : VMessageImageData.fromMap(
              map['thumbImage'] as Map<String, dynamic>,
              baseUrl: baseUrl,
            ),
    );
  }

//</editor-fold>
}
