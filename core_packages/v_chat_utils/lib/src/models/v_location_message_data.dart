import 'package:latlong2/latlong.dart';

import 'link_preview_data.dart';

class VLocationMessageData {
  final LatLng latLng;
  final VLinkPreviewData linkPreviewData;

  VLocationMessageData({
    required this.latLng,
    required this.linkPreviewData,
  });

  @override
  String toString() {
    return 'VLocationMessageData{latLng: $latLng, linkPreviewData: $linkPreviewData}';
  } // from json
  VLocationMessageData.fromMap(Map<String, dynamic> json)
      : latLng = LatLng(
          json['lat'] as double,
          json['long'] as double,
        ),
        linkPreviewData = VLinkPreviewData.fromMap(
          json['linkPreviewData'] as Map<String, dynamic>,
        );

  // to json
  Map<String, dynamic> toMap() => {
        'lat': latLng.latitude,
        'long': latLng.longitude,
        'linkPreviewData': linkPreviewData.toMap(),
      };
}
