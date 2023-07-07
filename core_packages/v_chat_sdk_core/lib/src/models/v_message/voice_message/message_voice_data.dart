// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_platform/v_platform.dart';

class VMessageVoiceData {
  /// The file source data
  VPlatformFile fileSource;

  /// The duration of the voice in milliseconds
  int duration;

//<editor-fold desc="Data Methods">
  Duration get durationObj => Duration(milliseconds: duration);

  VMessageVoiceData({
    required this.fileSource,
    required this.duration,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VMessageVoiceData &&
          runtimeType == other.runtimeType &&
          fileSource == other.fileSource &&
          duration == other.duration);

  @override
  int get hashCode => fileSource.hashCode ^ duration.hashCode;

  @override
  String toString() {
    return 'MessageVoiceData{ fileSource: $fileSource, duration: $duration,}';
  }

  VMessageVoiceData copyWith({
    VPlatformFile? fileSource,
    int? duration,
  }) {
    return VMessageVoiceData(
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

  factory VMessageVoiceData.fromMap(
    Map<String, dynamic> map,
  ) {
    return VMessageVoiceData(
      fileSource: VPlatformFile.fromMap(map),
      duration: map['duration'] as int,
    );
  }

//</editor-fold>
}
