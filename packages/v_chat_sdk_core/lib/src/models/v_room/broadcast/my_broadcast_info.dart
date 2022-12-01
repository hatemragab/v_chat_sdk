class MyBroadcastInfo {
  final int totalUsers;

//<editor-fold desc="Data Methods">

  const MyBroadcastInfo({
    required this.totalUsers,
  });

  MyBroadcastInfo.empty() : totalUsers = 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MyBroadcastInfo &&
          runtimeType == other.runtimeType &&
          totalUsers == other.totalUsers);

  @override
  int get hashCode => totalUsers.hashCode;

  @override
  String toString() {
    return 'MyBroadcastInfo{ totalUsers: $totalUsers,}';
  }

  MyBroadcastInfo copyWith({
    int? totalUsers,
  }) {
    return MyBroadcastInfo(
      totalUsers: totalUsers ?? this.totalUsers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalUsers': totalUsers,
    };
  }

  factory MyBroadcastInfo.fromMap(Map<String, dynamic> map) {
    return MyBroadcastInfo(
      totalUsers: map['totalUsers'] as int,
    );
  }

//</editor-fold>
}
