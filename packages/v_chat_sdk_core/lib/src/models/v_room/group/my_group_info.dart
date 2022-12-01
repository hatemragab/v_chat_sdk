class MyGroupInfo {
  bool isMeOut;
  int membersCount;

//<editor-fold desc="Data Methods">

  MyGroupInfo({
    required this.isMeOut,
    required this.membersCount,
  });

  MyGroupInfo.empty()
      : membersCount = 0,
        isMeOut = false;

  @override
  String toString() {
    return 'MyGroupInfo{ isMeOut: $isMeOut, membersCount: $membersCount,}';
  }

  MyGroupInfo copyWith({
    bool? isMeOut,
    int? membersCount,
  }) {
    return MyGroupInfo(
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

  factory MyGroupInfo.fromMap(Map<String, dynamic> map) {
    return MyGroupInfo(
      isMeOut: map['isMeOut'] as bool,
      membersCount: map['membersCount'] as int,
    );
  }

//</editor-fold>
}
