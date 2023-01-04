import '../../v_chat_utils.dart';

class VMessageVideoData {
  VPlatformFileSource fileSource;
  VMessageImageData? thumbImage;
  int duration;

  Duration get durationObj => Duration(milliseconds: duration);

  String get dateFormat {
    return '$durationObj'.split('.')[0].padLeft(8, '0');
  }

//<editor-fold desc="Data Methods">

  VMessageVideoData({
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

  factory VMessageVideoData.fromMap(Map<String, dynamic> map) {
    return VMessageVideoData(
      fileSource: VPlatformFileSource.fromMap(map),
      duration: map['duration'] == null ? 0 : map['duration'] as int,
      thumbImage: map['thumbImage'] == null
          ? null
          : VMessageImageData.fromMap(
              map['thumbImage'] as Map<String, dynamic>,
            ),
    );
  }

//</editor-fold>
}
