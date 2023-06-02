// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class VCustomMsgData {
  ///Your custom data as a map
  final Map<String, dynamic> data;

//<editor-fold desc="Data Methods">

  VCustomMsgData({
    required this.data,
  });

  @override
  String toString() {
    return 'VCustomMsgAtt{data: $data}';
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
    };
  }

  factory VCustomMsgData.fromMap(Map<String, dynamic> map) {
    return VCustomMsgData(
      data: map['data'] as Map<String, dynamic>,
    );
  }

//</editor-fold>
}
