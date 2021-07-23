import 'package:dio/dio.dart';
import 'package:get/get.dart';


class VchatMessageAttachment {
  CancelToken? cancelToken;

  final String? imageUrl;
  final String? playUrl;
  final String? fileSize;
  final String? fileDuration;
  final String? width;
  final String? height;
  final String? lat;
  final String? lang;
  final String? linkTitle;
  final String? linkDescription;
  final String? linkDataUrl;

  final RxString progress = "0 %".obs;
  final Rx<Duration> maxDuration = Duration(milliseconds: 1).obs;

  final Rx<Duration> currentPlayPosition = Duration.zero.obs;
  final RxBool isVoicePlying = false.obs;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  VchatMessageAttachment({
    this.imageUrl,
    this.cancelToken,
    this.playUrl,
    required this.fileSize,
    this.fileDuration,
    this.width,
    this.height,
    this.lat,
    this.lang,
    this.linkTitle,
    this.linkDescription,
    this.linkDataUrl,
  });

  VchatMessageAttachment copyWith({
    String? imageUrl,
    String? playUrl,
    String? fileSize,
    String? fileDuration,
    String? width,
    String? height,
    String? lat,
    String? lang,
    String? linkTitle,
    String? linkDescription,
    String? linkDataUrl,
  }) {
    return VchatMessageAttachment(
      imageUrl: imageUrl ?? this.imageUrl,
      playUrl: playUrl ?? this.playUrl,
      fileSize: fileSize ?? this.fileSize,
      fileDuration: fileDuration ?? this.fileDuration,
      width: width ?? this.width,
      height: height ?? this.height,
      lat: lat ?? this.lat,
      lang: lang ?? this.lang,
      linkTitle: linkTitle ?? this.linkTitle,
      linkDescription: linkDescription ?? this.linkDescription,
      linkDataUrl: linkDataUrl ?? this.linkDataUrl,
    );
  }


  @override
  String toString() {
    return 'MessageAttachment{cancelToken: $cancelToken, imageUrl: $imageUrl, playUrl: $playUrl, fileSize: $fileSize, fileDuration: $fileDuration, width: $width, height: $height, lat: $lat, lang: $lang, linkTitle: $linkTitle, linkDescription: $linkDescription, linkDataUrl: $linkDataUrl, progress: $progress, maxDuration: $maxDuration, currentPlayPosition: $currentPlayPosition, isVoicePlying: $isVoicePlying}';
  }

  factory VchatMessageAttachment.fromMap(Map<String, dynamic> map) {
    return VchatMessageAttachment(
      imageUrl: map['imageUrl'] as String?,
      playUrl: map['playUrl'] as String?,
      fileSize: map['fileSize'] as String?,
      fileDuration: map['fileDuration'] as String?,
      width: map['width'] as String?,
      height: map['height'] as String?,
      lat: map['lat'] as String?,
      lang: map['lang'] as String?,
      linkTitle: map['linkTitle'] as String?,
      linkDescription: map['linkDescription'] as String?,
      linkDataUrl: map['linkDataUrl'] as String?,
    );
  }

  Map<String, dynamic> toLocalMap() {
    // ignore: unnecessary_cast
    return {
      'imageUrl': imageUrl,
      'playUrl': playUrl,
      'fileSize': fileSize,
      'fileDuration': fileDuration,
      'width': width,
      'height': height,
      'lat': lat,
      'lang': lang,
      'linkTitle': linkTitle,
      'linkDescription': linkDescription,
      'linkDataUrl': linkDataUrl,
    } as Map<String, dynamic>;
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'imageUrl': imageUrl.toString(),
      'playUrl': playUrl.toString(),
      'fileSize': fileSize.toString(),
      'fileDuration': fileDuration.toString(),
      'width': width.toString(),
      'height': height.toString(),
      'lat': lat.toString(),
      'lang': lang.toString(),
      'linkTitle': linkTitle.toString(),
      'linkDescription': linkDescription.toString(),
      'linkDataUrl': linkDataUrl.toString(),
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
