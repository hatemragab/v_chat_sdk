// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_platform/v_platform.dart';

class MessageImageData {
  VPlatformFile fileSource;
  int width;
  int height;

//<editor-fold desc="Data Methods">

  MessageImageData({
    required this.fileSource,
    required this.width,
    required this.height,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageImageData &&
          runtimeType == other.runtimeType &&
          fileSource == other.fileSource &&
          width == other.width &&
          height == other.height);

  @override
  int get hashCode => fileSource.hashCode ^ width.hashCode ^ height.hashCode;

  @override
  String toString() {
    return 'MessageImageData{ fileSource: $fileSource, width: $width, height: $height,}';
  }

  bool get isFromPath => fileSource.fileLocalPath != null;

  bool get isFromBytes => fileSource.bytes != null;

  MessageImageData copyWith({
    VPlatformFile? fileSource,
    int? width,
    int? height,
  }) {
    return MessageImageData(
      fileSource: fileSource ?? this.fileSource,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ...fileSource.toMap(),
      'width': width,
      'height': height,
    };
  }

  factory MessageImageData.fromMap(
    Map<String, dynamic> map, {
    String? baseUrl,
  }) {
    return MessageImageData(
      fileSource: VPlatformFile.fromMap(
        map: map,
        baseUrl: baseUrl,
      ),
      width: map['width'] as int,
      height: map['height'] as int,
    );
  }

  factory MessageImageData.fromFakeData({
    required int high,
    required int width,
  }) {
    return MessageImageData(
      fileSource: VPlatformFile.fromUrl(
        url: "https://picsum.photos/$width/$high",
      ),
      width: width,
      height: high,
    );
  }

//</editor-fold>
}
