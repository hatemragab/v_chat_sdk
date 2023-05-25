// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:latlong2/latlong.dart';

import 'link_preview_data.dart';

class LocationMessageData {
  final LatLng latLng;
  final LinkPreviewData linkPreviewData;

  LocationMessageData({
    required this.latLng,
    required this.linkPreviewData,
  });

  @override
  String toString() {
    return 'VLocationMessageData{latLng: $latLng, linkPreviewData: $linkPreviewData}';
  } // from json

  LocationMessageData.fromMap(Map<String, dynamic> json)
      : latLng = LatLng(
          double.parse(json['lat'].toString()),
          double.parse(json['long'].toString()),
        ),
        linkPreviewData = LinkPreviewData.fromMap(
          json['linkPreviewData'] as Map<String, dynamic>,
        );

  // to json
  Map<String, dynamic> toMap() => {
        'lat': latLng.latitude.toString(),
        'long': latLng.longitude.toString(),
        'linkPreviewData': linkPreviewData.toMap(),
      };
}
