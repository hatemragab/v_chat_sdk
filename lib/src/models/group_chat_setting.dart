class GroupChatSetting {
  final String title;
  final String image;
  final String imageThumb;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const GroupChatSetting({
    required this.title,
    required this.image,
    required this.imageThumb,
  });

  GroupChatSetting copyWith({
    String? title,
    String? image,
    String? imageThumb,
  }) {
    return GroupChatSetting(
      title: title ?? this.title,
      image: image ?? this.image,
      imageThumb: imageThumb ?? this.imageThumb,
    );
  }

  @override
  String toString() {
    return 'GroupChatSetting{title: $title, image: $image, imageThumb: $imageThumb}';
  }

  factory GroupChatSetting.fromMap(Map<String, dynamic> map) {
    return GroupChatSetting(
      title: (map['title'] as String),
      image: (map['image'] as String),
      imageThumb: (map['imageThumb'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'title': title,
      'image': image,
      'imageThumb': imageThumb,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
