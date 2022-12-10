import '../../../types/platform_file_source.dart';

class VMessageVoiceData {
  PlatformFileSource fileSource;
  int duration;

//<editor-fold desc="Data Methods">
  Duration get durationObj => Duration(milliseconds: duration);

  VMessageVoiceData({
    required this.fileSource,
    required this.duration,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VMessageVoiceData &&
          runtimeType == other.runtimeType &&
          fileSource == other.fileSource &&
          duration == other.duration);

  @override
  int get hashCode => fileSource.hashCode ^ duration.hashCode;

  @override
  String toString() {
    return 'MessageVoiceData{ fileSource: $fileSource, duration: $duration,}';
  }

  VMessageVoiceData copyWith({
    PlatformFileSource? fileSource,
    int? duration,
  }) {
    return VMessageVoiceData(
      fileSource: fileSource ?? this.fileSource,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ...fileSource.toMap(),
      'duration': duration,
    };
  }

  factory VMessageVoiceData.fromMap(Map<String, dynamic> map) {
    return VMessageVoiceData(
      fileSource: PlatformFileSource.fromMap(map),
      duration: map['duration'] as int,
    );
  }

//</editor-fold>
}
