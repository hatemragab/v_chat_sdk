import 'dart:io';
import 'dart:typed_data';

import 'package:file_sizes/file_sizes.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';

import '../../v_chat_sdk_core.dart';

class PlatformFileSource {
  String name;
  VFullUrlModel? url;
  String? filePath;
  List<int>? bytes;
  String? mimeType;
  int fileSize;

  PlatformFileSource._({
    required this.name,
    this.url,
    this.filePath,
    this.bytes,
    required this.fileSize,
    this.mimeType,
  });

  String? get getMimeType => mime(name);

  bool get isFromPath => filePath != null;

  bool get isFromBytes => bytes != null;

  bool get isFromUrl => url != null;

  bool get isNotUrl => isFromBytes || isFromPath;

  String get readableSize => FileSize.getSize(fileSize);

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

  PlatformFileSource.fromBytes({
    required this.name,
    required List<int> this.bytes,
  }) : fileSize = bytes.length {
    //final mime = lookupMimeType('', headerBytes: bytes);
    mimeType = getMimeType;
  }

  PlatformFileSource.fromPath({
    required String this.filePath,
  })  : fileSize = File(filePath).lengthSync(),
        name = basename(filePath) {
    mimeType = getMimeType;
  }

  PlatformFileSource.fromUrl({
    this.fileSize = 0,
    required String url,
    bool isFullUrl = false,
  })  : url = VFullUrlModel(url, isFullUrl),
        name = basename(url) {
    mimeType = getMimeType;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url == null ? null : url!.originalUrl,
      'filePath': filePath,
      'bytes': bytes,
      'mimeType': getMimeType,
      'fileSize': fileSize,
    };
  }

  @override
  String toString() {
    return 'PlatformFileSource{name: $name, url:$url filePath: $filePath, mimeType: $mimeType, size: $fileSize bytes ${bytes?.length}';
  }

  SupportedFilesType get getMediaType {
    final mimeStr = mimeType;
    if (mimeStr == null) return SupportedFilesType.file;
    final fileType = mimeStr.split('/').first;
    if (fileType == "video") {
      return SupportedFilesType.video;
    }
    if (fileType == "image") {
      return SupportedFilesType.image;
    }
    return SupportedFilesType.file;
  }

  factory PlatformFileSource.fromMap(Map<String, dynamic> map) {
    if (map['filePath'] == null && map['bytes'] == null && map['url'] == null) {
      throw "PlatformFileSource.fromMap at lest filePath or bytes or url not null $map";
    }
    return PlatformFileSource._(
      name: map['name'] as String,
      url: map['url'] == null ? null : VFullUrlModel(map['url'] as String),
      filePath: map['filePath'] as String?,
      bytes: map['bytes'] as List<int>?,
      // bytes: (map['bytes'] as List?) ==null?null:(map['bytes'] as List).map((e) => null) ,
      mimeType: map['mimeType'] as String?,
      fileSize: map['fileSize'] as int,
    );
  }
}
