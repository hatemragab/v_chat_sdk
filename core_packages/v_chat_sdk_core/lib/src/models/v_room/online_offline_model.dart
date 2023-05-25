// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:event_bus_plus/res/app_event.dart';

class VOnlineOfflineModel extends AppEvent {
  final String peerId;
  final bool isOnline;
  final String roomId;

//<editor-fold desc="Data Methods">

  const VOnlineOfflineModel({
    required this.peerId,
    required this.isOnline,
    required this.roomId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VOnlineOfflineModel &&
          runtimeType == other.runtimeType &&
          peerId == other.peerId &&
          isOnline == other.isOnline);

  @override
  int get hashCode => peerId.hashCode ^ isOnline.hashCode;

  @override
  String toString() {
    return 'OnlineOfflineModel{ peerId: $peerId, isOnline: $isOnline, roomId $roomId}';
  }

  Map<String, dynamic> toMap() {
    return {
      'peerId': peerId,
      'extra': roomId,
    };
  }

  factory VOnlineOfflineModel.fromMap(Map<String, dynamic> map) {
    return VOnlineOfflineModel(
      peerId: map['peerId'] as String,
      isOnline: map['isOnline'] as bool,
      roomId: map['extra'] as String,
    );
  }

  @override
  List<Object?> get props => [peerId, roomId, isOnline];

//</editor-fold>
}
