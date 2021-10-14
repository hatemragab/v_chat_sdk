import 'package:get/get.dart';

class GroupChatSetting {
  final RxString title;
  final RxString image;
  final RxString imageThumb;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const GroupChatSetting({
    required this.title,
    required this.image,
    required this.imageThumb,
  });

  GroupChatSetting copyWith({
    RxString? title,
    RxString? image,
    RxString? imageThumb,
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
      title: (map['title'] as String).obs,
      image: (map['image'] as String).obs,
      imageThumb: (map['imageThumb'] as String).obs,
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
