// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class VCheckBanModel {
  final bool isMeBanner;
  final bool isPeerBanner;

//<editor-fold desc="Data Methods">
  const VCheckBanModel({
    required this.isMeBanner,
    required this.isPeerBanner,
  });
  bool get isThereBan => isMeBanner == true || isPeerBanner == true;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VCheckBanModel &&
          runtimeType == other.runtimeType &&
          isMeBanner == other.isMeBanner &&
          isPeerBanner == other.isPeerBanner);

  @override
  int get hashCode => isMeBanner.hashCode ^ isPeerBanner.hashCode;

  @override
  String toString() {
    return 'VCheckBanModel{ isMeBanner: $isMeBanner, isPeerBanner: $isPeerBanner,}';
  }

  VCheckBanModel copyWith({
    bool? isMeBanner,
    bool? isPeerBanner,
  }) {
    return VCheckBanModel(
      isMeBanner: isMeBanner ?? this.isMeBanner,
      isPeerBanner: isPeerBanner ?? this.isPeerBanner,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isMeBanner': isMeBanner,
      'isPeerBanner': isPeerBanner,
    };
  }

  factory VCheckBanModel.fromMap(Map<String, dynamic> map) {
    return VCheckBanModel(
      isMeBanner: map['isMeBanner'] as bool,
      isPeerBanner: map['isPeerBanner'] as bool,
    );
  }

//</editor-fold>
}
