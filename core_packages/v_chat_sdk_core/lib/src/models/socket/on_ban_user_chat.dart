class OnBanUserChatModel {
  final bool banned;
  final String? bannerId;
  final String roomId;

//<editor-fold desc="Data Methods">

  const OnBanUserChatModel({
    required this.banned,
    this.bannerId,
    required this.roomId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OnBanUserChatModel &&
          runtimeType == other.runtimeType &&
          banned == other.banned &&
          bannerId == other.bannerId &&
          roomId == other.roomId);

  @override
  int get hashCode => banned.hashCode ^ bannerId.hashCode ^ roomId.hashCode;

  @override
  String toString() {
    return 'OnBanUserChat{' +
        ' banned: $banned,' +
        ' bannerId: $bannerId,' +
        ' roomId: $roomId,' +
        '}';
  }

  OnBanUserChatModel copyWith({
    bool? banned,
    String? bannerId,
    String? roomId,
  }) {
    return OnBanUserChatModel(
      banned: banned ?? this.banned,
      bannerId: bannerId ?? this.bannerId,
      roomId: roomId ?? this.roomId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'banned': this.banned,
      'bannerId': this.bannerId,
      'roomId': this.roomId,
    };
  }

  factory OnBanUserChatModel.fromMap(Map<String, dynamic> map) {
    return OnBanUserChatModel(
      banned: map['banned'] as bool,
      bannerId: map['bannerId'] as String?,
      roomId: map['roomId'] as String,
    );
  }

//</editor-fold>
}
