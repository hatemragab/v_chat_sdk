import 'package:v_chat_sdk_core/src/types/platform_file_source.dart';

import 'message_image_data.dart';

extension on Duration {
  String format() => '$this'.split('.')[0].padLeft(8, '0');
}

class MessageVideoData {
  PlatformFileSource fileSource;
  MessageImageData? thumbImage;
  int duration;

  Duration get durationObj => Duration(milliseconds: duration);

  String get dateFormat {
    return durationObj.format();
  }

//<editor-fold desc="Data Methods">

  MessageVideoData({
    required this.fileSource,
    this.thumbImage,
    required this.duration,
  });

  bool get isFromPath => fileSource.filePath != null;

  bool get isFromBytes => fileSource.bytes != null;

  @override
  String toString() {
    return 'MessageVideoData{fileSource: $fileSource, thumbImageSource: $thumbImage, duration: $duration}';
  }

  Map<String, dynamic> toMap() {
    return {
      ...fileSource.toMap(),
      'duration': duration,
      'thumbImage': thumbImage == null ? null : thumbImage!.toMap(),
    };
  }

  factory MessageVideoData.fromMap(Map<String, dynamic> map) {
    return MessageVideoData(
      fileSource: PlatformFileSource.fromMap(map),
      duration: map['duration'] == null ? 0 : map['duration'] as int,
      thumbImage: map['thumbImage'] == null
          ? null
          : MessageImageData.fromMap(
              map['thumbImage'] as Map<String, dynamic>,
            ),
    );
  }

//</editor-fold>
}
