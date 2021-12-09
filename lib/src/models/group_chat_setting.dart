class GroupChatSetting {
  final String title;

  final String imageThumb;
  final int groupMembers;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const GroupChatSetting({
    required this.title,
    required this.imageThumb,
    required this.groupMembers,
  });

  GroupChatSetting copyWith({
    String? title,
    String? imageThumb,
    int? groupMembers,
  }) {
    return GroupChatSetting(
      title: title ?? this.title,
      groupMembers: groupMembers ?? this.groupMembers,
      imageThumb: imageThumb ?? this.imageThumb,
    );
  }

  @override
  String toString() {
    return 'GroupChatSetting{title: $title,   imageThumb: $imageThumb , groupMembers:$groupMembers}';
  }

  factory GroupChatSetting.fromMap(Map<String, dynamic> map) {
    return GroupChatSetting(
      title: (map['name'] as String),
      groupMembers: (map['groupMembers'] as int),
      imageThumb: (map['imageThumb'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'name': title,
      'groupMembers': groupMembers,
      'imageThumb': imageThumb,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
