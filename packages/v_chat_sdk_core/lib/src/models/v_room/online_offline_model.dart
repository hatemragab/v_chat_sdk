class OnlineOfflineModel {
  final String peerId;
  final bool isOnline;

//<editor-fold desc="Data Methods">

  const OnlineOfflineModel({
    required this.peerId,
    required this.isOnline,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OnlineOfflineModel &&
          runtimeType == other.runtimeType &&
          peerId == other.peerId &&
          isOnline == other.isOnline);

  @override
  int get hashCode => peerId.hashCode ^ isOnline.hashCode;

  @override
  String toString() {
    return 'OnlineOfflineModel{ peerId: $peerId, isOnline: $isOnline,}';
  }

  OnlineOfflineModel copyWith({
    String? peerId,
    bool? isOnline,
  }) {
    return OnlineOfflineModel(
      peerId: peerId ?? this.peerId,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'peerId': peerId,
      'isOnline': isOnline,
    };
  }

  factory OnlineOfflineModel.fromMap(Map<String, dynamic> map) {
    return OnlineOfflineModel(
      peerId: map['peerId'] as String,
      isOnline: map['isOnline'] as bool,
    );
  }

//</editor-fold>
}
