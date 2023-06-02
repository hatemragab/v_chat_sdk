// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// Represents the call attributes of a message.
///
/// This class is used to store various call-related details of a message such as call status,
/// start time, end time, and video call status.
class VMsgCallAtt {
  /// Call status of the message.
  final VMessageCallStatus callStatus;

  /// End time of the call.
  final String? endAt;

  /// Start time of the call.
  final String startAt;

  /// Indicates if it's a video call.
  final bool withVideo;

  VMsgCallAtt({
    required this.callStatus,
    required this.endAt,
    required this.startAt,
    required this.withVideo,
  });

  /// Provides end time of the call as a DateTime object.
  DateTime? get endAtDate =>
      endAt == null ? null : DateTime.parse(endAt!).toUtc();

  /// Provides start time of the call as a DateTime object.
  DateTime get startAtDate => DateTime.parse(startAt).toUtc();

  /// Provides the duration of the call in seconds as a string.
  String? get duration {
    if (endAt == null) return null;
    return endAtDate!.difference(startAtDate).inSeconds.toString();
  }

  @override
  String toString() {
    return 'VMsgCallAtt{callStatus: $callStatus, endAt: $endAt, startAt: $startAt, withVideo: $withVideo}';
  }

  /// Converts the call attributes into a map.
  Map<String, dynamic> toMap() {
    return {
      'callStatus': callStatus.name,
      'endAt': endAt,
      'startAt': startAt,
      'withVideo': withVideo,
    };
  }

  /// Creates a VMsgCallAtt object from a map.
  factory VMsgCallAtt.fromMap(Map<String, dynamic> map) {
    return VMsgCallAtt(
      callStatus: VMessageCallStatus.values.byName(map['callStatus'] as String),
      endAt: map['endAt'] as String?,
      startAt: (map['startAt'] as String?) ??
          DateTime.now().toLocal().toIso8601String(),
      withVideo: map['withVideo'] as bool,
    );
  }
}
