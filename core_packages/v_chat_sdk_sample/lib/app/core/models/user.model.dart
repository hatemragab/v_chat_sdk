// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_platform/v_platform.dart';

class UserModel {
  final String id;
  String userName;
  final DateTime createdAt;
  String imageUrl;

//<editor-fold desc="Data Methods">

  UserModel({
    required this.id,
    required this.userName,
    required this.createdAt,
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
          userName == other.userName &&
          createdAt == other.createdAt &&
          imageUrl == other.imageUrl);

  @override
  int get hashCode =>
      id.hashCode ^ userName.hashCode ^ createdAt.hashCode ^ imageUrl.hashCode;

  @override
  String toString() {
    return 'UserModel{ uid: $id, userName: $userName, createdAt: $createdAt, imageUrl: $imageUrl,}';
  }

  UserModel copyWith({
    String? id,
    String? userName,
    DateTime? createdAt,
    String? imageUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userName': userName,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] as String,
      userName: map['userName'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      imageUrl: map['imageUrl'] as String,
    );
  }

//</editor-fold>
}
// import 'package:v_platform/v_platform.dart';import 'package:v_chat_utils/v_chat_utils.dart';
//
// class UserModel {
//   final String id;
//   String userName;
//   final DateTime createdAt;
//   String imageUrl;
//
// //<editor-fold desc="Data Methods">
//
//   UserModel({
//     required this.id,
//     required this.userName,
//     required this.createdAt,
//     required this.imageUrl,
//   });
//
//   VPlatformFile get imgAsPlatformSource => VPlatformFile.fromUrl(
//         fileSize: 0,
//         url: imageUrl,
//         isFullUrl: true,
//       );
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is UserModel &&
//           runtimeType == other.runtimeType &&
//           id == other.id &&
//           userName == other.userName &&
//           createdAt == other.createdAt &&
//           imageUrl == other.imageUrl);
//
//   @override
//   int get hashCode =>
//       id.hashCode ^ userName.hashCode ^ createdAt.hashCode ^ imageUrl.hashCode;
//
//   @override
//   String toString() {
//     return 'UserModel{ uid: $id, userName: $userName, createdAt: $createdAt, imageUrl: $imageUrl,}';
//   }
//
//   UserModel copyWith({
//     String? uid,
//     String? userName,
//     DateTime? createdAt,
//     String? imageUrl,
//   }) {
//     return UserModel(
//       id: uid ?? this.id,
//       userName: userName ?? this.userName,
//       createdAt: createdAt ?? this.createdAt,
//       imageUrl: imageUrl ?? this.imageUrl,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'user_name': userName,
//       'image_url': imageUrl,
//       'register_type': "email",
//       'created_at': createdAt.toIso8601String(),
//     };
//   }
//
//   Map<String, dynamic> toApiMap() {
//     return {
//       'user_name': userName,
//       'image_url': imageUrl,
//       'register_type': "email",
//     };
//   }
//
//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       id: map['id'] as String,
//       userName: map['user_name'] as String,
//       createdAt: DateTime.parse(map['created_at']),
//       imageUrl: map['image_url'] as String,
//     );
//   }
//
// //</editor-fold>
// }
