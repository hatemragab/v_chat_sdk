// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class VSingleBlockModel {
  final bool isMeBanner;
  final bool isPeerBanner;
  final String roomId;

//<editor-fold desc="Data Methods">
  const VSingleBlockModel({
    required this.isMeBanner,
    required this.isPeerBanner,
    required this.roomId,
  });

  bool get isThereBan => isMeBanner == true || isPeerBanner == true;

  @override
  String toString() {
    return 'VSingleBlockModel{isMeBanner: $isMeBanner, isPeerBanner: $isPeerBanner, roomId: $roomId}';
  }

  Map<String, dynamic> toMap() {
    return {
      'isMeBanner': isMeBanner,
      'isPeerBanner': isPeerBanner,
      'roomId': roomId,
    };
  }

  factory VSingleBlockModel.fromMap(Map<String, dynamic> map) {
    return VSingleBlockModel(
      isMeBanner: map['isMeBanner'] as bool,
      isPeerBanner: map['isPeerBanner'] as bool,
      roomId: (map['roomId'] as String?) ?? "",
    );
  }

//</editor-fold>
}
