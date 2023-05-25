// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_platform/v_platform.dart';

class VMessageImageData {
  VPlatformFile fileSource;
  int width;
  int height;

//<editor-fold desc="Data Methods">

  VMessageImageData({
    required this.fileSource,
    required this.width,
    required this.height,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VMessageImageData &&
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

  VMessageImageData copyWith({
    VPlatformFile? fileSource,
    int? width,
    int? height,
  }) {
    return VMessageImageData(
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

  factory VMessageImageData.fromMap(
    Map<String, dynamic> map, {
    String? baseUrl,
  }) {
    return VMessageImageData(
      fileSource: VPlatformFile.fromMap(
        map: map,
        baseUrl: baseUrl,
      ),
      width: map['width'] as int,
      height: map['height'] as int,
    );
  }

  factory VMessageImageData.fromFakeData({
    required int high,
    required int width,
  }) {
    return VMessageImageData(
      fileSource: VPlatformFile.fromUrl(
        url: "https://picsum.photos/$width/$high",
      ),
      width: width,
      height: high,
    );
  }

//</editor-fold>
}
