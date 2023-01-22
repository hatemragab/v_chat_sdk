import 'dart:io';
import 'dart:typed_data';

import 'package:file_sizes/file_sizes.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';

import '../utils/enums.dart';

class VPlatformFileSource {
  String name;
  String? url;
  String? assetsPath;
  String? filePath;
  List<int>? bytes;
  String? mimeType;
  int fileSize;

  VPlatformFileSource._({
    required this.name,
    this.url,
    this.filePath,
    this.bytes,
    required this.fileSize,
    this.mimeType,
  });

  String? get getMimeType => mime(name);

  bool get isFromPath => filePath != null;

  bool get isFromAssets => assetsPath != null;

  bool get isFromBytes => bytes != null;

  bool get isFromUrl => url != null;

  bool get isNotUrl => isFromBytes || isFromPath;

  String get readableSize => FileSize.getSize(fileSize);

  String get getUrlPath {
    final uri = Uri.parse(url!);
    return "${uri.scheme}://${uri.host}${uri.path}";
  }

  List<int> get getBytes {
    if (bytes != null) {
      return bytes!;
    }
    if (filePath != null) {
      return File(filePath!).readAsBytesSync().toList();
    }
    throw UnimplementedError();
  }

  Uint8List get uint8List {
    return Uint8List.fromList(getBytes);
  }

  VPlatformFileSource.fromBytes({
    required this.name,
    required List<int> this.bytes,
  }) : fileSize = bytes.length {
    //final mime = lookupMimeType('', headerBytes: bytes);
    mimeType = getMimeType;
  }

  VPlatformFileSource.fromPath({
    required String this.filePath,
  })  : fileSize = File(filePath).lengthSync(),
        name = basename(filePath) {
    mimeType = getMimeType;
  }

  VPlatformFileSource.fromUrl({
    this.fileSize = 0,
    required String this.url,
  }) : name = basename(url) {
    mimeType = getMimeType;
  }

  VPlatformFileSource.fromAssets({
    this.fileSize = 0,
    required String this.assetsPath,
  }) : name = basename(assetsPath) {
    mimeType = getMimeType;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url == null ? null : url!,
      'filePath': filePath,
      'assetsPath': assetsPath,
      'bytes': bytes,
      'mimeType': getMimeType,
      'fileSize': fileSize,
    };
  }

  @override
  String toString() {
    return 'PlatformFileSource{name: $name, url:$url filePath: $filePath, mimeType: $mimeType, assetsPath: $assetsPath, size: $fileSize bytes ${bytes?.length}';
  }

  VSupportedFilesType get getMediaType {
    final mimeStr = mimeType;
    if (mimeStr == null) return VSupportedFilesType.file;
    final fileType = mimeStr.split('/').first;
    if (fileType == "video") {
      return VSupportedFilesType.video;
    }
    if (fileType == "image") {
      return VSupportedFilesType.image;
    }
    return VSupportedFilesType.file;
  }

  bool get isContentFile => getMediaType == VSupportedFilesType.file;

  bool get isContentVideo => getMediaType == VSupportedFilesType.video;

  bool get isContentImage => getMediaType == VSupportedFilesType.image;

  factory VPlatformFileSource.fromMap(Map<String, dynamic> map) {
    if (map['filePath'] == null && map['bytes'] == null && map['url'] == null) {
      throw "PlatformFileSource.fromMap at lest filePath or bytes or url not null $map";
    }
    return VPlatformFileSource._(
      name: map['name'] as String,
      url: map['url'] == null ? null : map['url'] as String,
      filePath: map['filePath'] as String?,
      bytes: map['bytes'] as List<int>?,
      // bytes: (map['bytes'] as List?) ==null?null:(map['bytes'] as List).map((e) => null) ,
      mimeType: map['mimeType'] as String?,
      fileSize: map['fileSize'] as int,
    );
  }
}
