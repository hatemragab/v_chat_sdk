// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VMsgCallAtt {
  final VMessageCallStatus callStatus;
  final String? endAt;
  final String startAt;
  final bool withVideo;

//<editor-fold desc="Data Methods">
  DateTime? get endAtDate =>
      endAt == null ? null : DateTime.parse(endAt!).toLocal();

  DateTime get startAtDate => DateTime.parse(startAt).toLocal();

  VMsgCallAtt({
    required this.callStatus,
    required this.endAt,
    required this.startAt,
    required this.withVideo,
  });

  String? get duration {
    if (endAt == null) return null;
    return endAtDate!.difference(startAtDate).inSeconds.toString();
  }

  @override
  String toString() {
    return 'VMsgCallAtt{callStatus: $callStatus, endAt: $endAt, startAt: $startAt, withVideo: $withVideo}';
  }

  Map<String, dynamic> toMap() {
    return {
      'callStatus': callStatus.name,
      'endAt': endAt,
      'startAt': startAt,
      'withVideo': withVideo,
    };
  }

  factory VMsgCallAtt.fromMap(Map<String, dynamic> map) {
    return VMsgCallAtt(
      callStatus: VMessageCallStatus.values.byName(map['callStatus'] as String),
      endAt: map['endAt'] as String?,
      startAt: (map['startAt'] as String?) ??
          DateTime.now().toLocal().toIso8601String(),
      withVideo: map['withVideo'] as bool,
    );
  }

//</editor-fold>
}
