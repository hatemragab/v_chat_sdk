// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.
import 'package:v_platform/v_platform.dart';

import 'message_image_data.dart';
import 'message_video_data.dart';

abstract class VBaseMediaRes {
  bool isSelected = false;
  final String id;

  VPlatformFile getVPlatformFile();

  VBaseMediaRes({
    required this.id,
  });

  @override
  bool operator ==(Object other) => other is VBaseMediaRes && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class VMediaImageRes extends VBaseMediaRes {
  MessageImageData data;

  VMediaImageRes({
    String? id,
    required this.data,
  }) : super(
          id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        );

  @override
  String toString() {
    return 'MediaEditorImage{data: $data }';
  }

  @override
  VPlatformFile getVPlatformFile() => data.fileSource;
}

class VMediaVideoRes extends VBaseMediaRes {
  MessageVideoData data;

  VMediaVideoRes({
    String? id,
    required this.data,
  }) : super(id: id ?? DateTime.now().microsecondsSinceEpoch.toString());

  @override
  VPlatformFile getVPlatformFile() => data.fileSource;

  @override
  String toString() {
    return 'MediaEditorVideo{data $data}';
  }
}

class VMediaFileRes extends VBaseMediaRes {
  VPlatformFile data;

  @override
  VPlatformFile getVPlatformFile() => data;

  VMediaFileRes({
    String? id,
    required this.data,
  }) : super(id: id ?? DateTime.now().microsecondsSinceEpoch.toString());

  @override
  String toString() {
    return 'MediaEditorFile{data $data}';
  }
}
