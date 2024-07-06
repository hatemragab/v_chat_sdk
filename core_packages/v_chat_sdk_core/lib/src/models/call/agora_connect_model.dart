// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class VAgoraConnect {
  final String channelName;
  final int uid;
  final String rtcToken;
  final String joinedAt;

//<editor-fold desc="Data Methods">
  const VAgoraConnect({
    required this.channelName,
    required this.uid,
    required this.rtcToken,
    required this.joinedAt,
  });

  @override
  String toString() {
    return 'VAgoraConnect{channelName: $channelName, uid: $uid, rtcToken: $rtcToken, joinedAt: $joinedAt}';
  }

  Map<String, dynamic> toMap() {
    return {
      'channelName': channelName,
      'uid': uid,
      'rtcToken': rtcToken,
      'joinedAt': joinedAt,
    };
  }

  factory VAgoraConnect.fromMap(Map<String, dynamic> map) {
    return VAgoraConnect(
      channelName: map['channelName'] as String,
      uid: int.parse(map['uid'].toString(), radix: 10),
      rtcToken: map['rtcToken'] as String,
      joinedAt: map['joinedAt'] as String,
    );
  }

//</editor-fold>
}
