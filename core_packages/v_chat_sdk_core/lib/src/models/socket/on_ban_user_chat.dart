// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class OnBanUserChatModel {
  final String roomId;

//<editor-fold desc="Data Methods">

  const OnBanUserChatModel({
    required this.roomId,
  });

  @override
  String toString() {
    return 'OnBanUserChat{roomId: $roomId,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
    };
  }

  factory OnBanUserChatModel.fromMap(Map<String, dynamic> map) {
    return OnBanUserChatModel(
      roomId: map['roomId'] as String,
    );
  }

//</editor-fold>
}
