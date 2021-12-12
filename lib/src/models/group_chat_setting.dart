class GroupChatSetting {
  final String title;

  final String imageThumb;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const GroupChatSetting({
    required this.title,
    required this.imageThumb,
  });

  GroupChatSetting copyWith({
    String? title,
    String? imageThumb,
    int? groupMembers,
  }) {
    return GroupChatSetting(
      title: title ?? this.title,

      imageThumb: imageThumb ?? this.imageThumb,
    );
  }

  @override
  String toString() {
    return 'GroupChatSetting{title: $title,   imageThumb: $imageThumb  }';
  }

  factory GroupChatSetting.fromMap(Map<String, dynamic> map) {
    return GroupChatSetting(
      title: (map['name'] as String),
      imageThumb: (map['imageThumb'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'name': title,
      'imageThumb': imageThumb,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
