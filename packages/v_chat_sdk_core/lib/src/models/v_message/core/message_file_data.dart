import '../../../types/platform_file_source.dart';

class VMessageFileData {
  PlatformFileSource fileSource;

//<editor-fold desc="Data Methods">

  VMessageFileData({
    required this.fileSource,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VMessageFileData &&
          runtimeType == other.runtimeType &&
          fileSource == other.fileSource);

  @override
  int get hashCode => fileSource.hashCode;

  @override
  String toString() {
    return 'MessageFileData{ fileSource: $fileSource,}';
  }

  VMessageFileData copyWith({
    PlatformFileSource? fileSource,
  }) {
    return VMessageFileData(
      fileSource: fileSource ?? this.fileSource,
    );
  }

  Map<String, dynamic> toMap() {
    return fileSource.toMap();
  }

  factory VMessageFileData.fromMap(Map<String, dynamic> map) {
    return VMessageFileData(
      fileSource: PlatformFileSource.fromMap(map),
    );
  }

//</editor-fold>
}
