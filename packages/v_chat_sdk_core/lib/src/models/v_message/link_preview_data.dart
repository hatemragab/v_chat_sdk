import '../../types/message_image_data.dart';

class VLinkPreviewData {
  final MessageImageData? image;
  final String? title;
  final String? desc;
  final String? link;

  const VLinkPreviewData({
    this.image,
    this.title,
    this.desc,
    this.link,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image == null ? null : image!.toMap(),
      'title': title,
      'desc': desc,
      'link': link,
    };
  }

  @override
  String toString() {
    return 'LinkPreviewData{image: $image, title: $title, desc: $desc, link: $link}';
  }

  factory VLinkPreviewData.fromMap(Map<String, dynamic> map) {
    return VLinkPreviewData(
      image: map['image'] == null
          ? null
          : MessageImageData.fromMap(
              map['image'] as Map<String, dynamic>,
            ),
      title: map['title'] as String?,
      desc: map['desc'] as String?,
      link: map['link'] as String?,
    );
  }
}
