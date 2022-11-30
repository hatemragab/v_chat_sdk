import '../v_full_url_model.dart';

class VUserImage {
  final VFullUrlModel fullImage;
  final VFullUrlModel chatImage;
  final VFullUrlModel smallImage;

//<editor-fold desc="Data Methods">

  const VUserImage({
    required this.fullImage,
    required this.chatImage,
    required this.smallImage,
  });

  VUserImage.fromSingleUrl(String url)
      : fullImage = VFullUrlModel(url),
        chatImage = VFullUrlModel(url),
        smallImage = VFullUrlModel(url);

  @override
  String toString() {
    return 'UserImage{'
        ' fullImage: $fullImage,'
        ' chatImage: $chatImage,'
        ' smallImage: $smallImage, '
        '}';
  }

  Map<String, dynamic> toMap() {
    return {
      'fullImage': fullImage.originalUrl,
      'chatImage': chatImage.originalUrl,
      'smallImage': smallImage.originalUrl,
    };
  }

  factory VUserImage.fromMap(Map<String, dynamic> map) {
    return VUserImage(
      fullImage: VFullUrlModel(map['fullImage'] as String),
      chatImage: VFullUrlModel(map['chatImage'] as String),
      smallImage: VFullUrlModel(map['smallImage'] as String),
    );
  }

//</editor-fold>
}
