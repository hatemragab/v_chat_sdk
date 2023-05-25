// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_platform/v_platform.dart';

class MessageVoiceData {
  VPlatformFile fileSource;
  int duration;

//<editor-fold desc="Data Methods">
  Duration get durationObj => Duration(milliseconds: duration);

  MessageVoiceData({
    required this.fileSource,
    required this.duration,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageVoiceData &&
          runtimeType == other.runtimeType &&
          fileSource == other.fileSource &&
          duration == other.duration);

  @override
  int get hashCode => fileSource.hashCode ^ duration.hashCode;

  @override
  String toString() {
    return 'MessageVoiceData{ fileSource: $fileSource, duration: $duration,}';
  }

  MessageVoiceData copyWith({
    VPlatformFile? fileSource,
    int? duration,
  }) {
    return MessageVoiceData(
      fileSource: fileSource ?? this.fileSource,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ...fileSource.toMap(),
      'duration': duration,
    };
  }

  factory MessageVoiceData.fromMap(
    Map<String, dynamic> map, {
    String? baseUrl,
  }) {
    return MessageVoiceData(
      fileSource: VPlatformFile.fromMap(map: map, baseUrl: baseUrl),
      duration: map['duration'] as int,
    );
  }

//</editor-fold>
}
