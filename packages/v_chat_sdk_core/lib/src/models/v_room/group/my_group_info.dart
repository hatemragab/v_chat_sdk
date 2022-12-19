class VMyGroupInfo {
  bool isMeOut;
  int membersCount;

//<editor-fold desc="Data Methods">

  VMyGroupInfo({
    required this.isMeOut,
    required this.membersCount,
  });

  VMyGroupInfo.empty()
      : membersCount = 0,
        isMeOut = false;

  @override
  String toString() {
    return 'MyGroupInfo{ isMeOut: $isMeOut, membersCount: $membersCount,}';
  }

  VMyGroupInfo copyWith({
    bool? isMeOut,
    int? membersCount,
  }) {
    return VMyGroupInfo(
      isMeOut: isMeOut ?? this.isMeOut,
      membersCount: membersCount ?? this.membersCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isMeOut': isMeOut,
      'membersCount': membersCount,
    };
  }

  factory VMyGroupInfo.fromMap(Map<String, dynamic> map) {
    return VMyGroupInfo(
      isMeOut: map['isMeOut'] as bool,
      membersCount: map['membersCount'] as int,
    );
  }

//</editor-fold>
}
