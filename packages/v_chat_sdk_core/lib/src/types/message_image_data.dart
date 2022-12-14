import 'package:v_chat_sdk_core/src/types/platform_file_source.dart';

class MessageImageData {
  PlatformFileSource fileSource;
  int width;
  int height;

//<editor-fold desc="Data Methods">

  MessageImageData({
    required this.fileSource,
    required this.width,
    required this.height,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageImageData &&
          runtimeType == other.runtimeType &&
          fileSource == other.fileSource &&
          width == other.width &&
          height == other.height);

  @override
  int get hashCode => fileSource.hashCode ^ width.hashCode ^ height.hashCode;

  @override
  String toString() {
    return 'MessageImageData{ fileSource: $fileSource, width: $width, height: $height,}';
  }

  bool get isFromPath => fileSource.filePath != null;

  bool get isFromBytes => fileSource.bytes != null;

  MessageImageData copyWith({
    PlatformFileSource? fileSource,
    int? width,
    int? height,
  }) {
    return MessageImageData(
      fileSource: fileSource ?? this.fileSource,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ...fileSource.toMap(),
      'width': width,
      'height': height,
    };
  }

  factory MessageImageData.fromMap(Map<String, dynamic> map) {
    return MessageImageData(
      fileSource: PlatformFileSource.fromMap(map),
      width: map['width'] as int,
      height: map['height'] as int,
    );
  }

  factory MessageImageData.fromFakeData() {
    return MessageImageData(
      fileSource: PlatformFileSource.fromUrl(
        url: "https://picsum.photos/600/600",
        isFullUrl: true,
      ),
      width: 600,
      height: 600,
    );
  }

//</editor-fold>
}
