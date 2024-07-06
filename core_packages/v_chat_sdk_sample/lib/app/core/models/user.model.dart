// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_platform/v_platform.dart';

class UserModel {
  final String id;
  String fullName;

  String imageUrl;

//<editor-fold desc="Data Methods">

  UserModel({
    required this.id,
    required this.fullName,
    required this.imageUrl,
  });

  VPlatformFile get imgAsPlatformSource => VPlatformFile.fromUrl(
        fileSize: 0,
        url: imageUrl,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          fullName == other.fullName &&
          imageUrl == other.imageUrl);

  @override
  int get hashCode => id.hashCode ^ fullName.hashCode ^ imageUrl.hashCode;

  @override
  String toString() {
    return 'UserModel{ uid: $id, userName: $fullName , imageUrl: $imageUrl,}';
  }

  UserModel copyWith({
    String? id,
    String? userName,
    String? imageUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: userName ?? this.fullName,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'fullName': fullName,
      'imageUrl': imageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] as String,
      fullName: map['fullName'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

//</editor-fold>
}
