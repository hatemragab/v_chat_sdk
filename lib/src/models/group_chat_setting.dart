class GroupChatSetting {
  final String title;
  final String imageThumb;
  final int isLeft;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const GroupChatSetting({
    required this.title,
    required this.imageThumb,
    required this.isLeft,
  });

  GroupChatSetting copyWith({
    String? title,
    String? imageThumb,
    int? groupMembers,
    int? isLeft,
  }) {
    return GroupChatSetting(
      title: title ?? this.title,

      imageThumb: imageThumb ?? this.imageThumb,
      isLeft: isLeft ?? this.isLeft,
    );
  }

  @override
  String toString() {
    return 'GroupChatSetting{title: $title,   imageThumb: $imageThumb  }';
  }

  factory GroupChatSetting.fromMap(Map<String, dynamic> map) {
    return GroupChatSetting(
      title: (map['name'] as String),
      isLeft: (map['isLeft'] as int),
      imageThumb: (map['imageThumb'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'name': title,
      'imageThumb': imageThumb,
      'isLeft': isLeft,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
