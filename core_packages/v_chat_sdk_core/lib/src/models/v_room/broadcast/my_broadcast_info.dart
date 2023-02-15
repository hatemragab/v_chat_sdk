// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class VMyBroadcastInfo {
  final int totalUsers;

//<editor-fold desc="Data Methods">

  const VMyBroadcastInfo({
    required this.totalUsers,
  });

  VMyBroadcastInfo.empty() : totalUsers = 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VMyBroadcastInfo &&
          runtimeType == other.runtimeType &&
          totalUsers == other.totalUsers);

  @override
  int get hashCode => totalUsers.hashCode;

  @override
  String toString() {
    return 'MyBroadcastInfo{ totalUsers: $totalUsers,}';
  }

  VMyBroadcastInfo copyWith({
    int? totalUsers,
  }) {
    return VMyBroadcastInfo(
      totalUsers: totalUsers ?? this.totalUsers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalUsers': totalUsers,
    };
  }

  factory VMyBroadcastInfo.fromMap(Map<String, dynamic> map) {
    return VMyBroadcastInfo(
      totalUsers: map['totalUsers'] as int,
    );
  }

//</editor-fold>
}
