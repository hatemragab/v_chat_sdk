// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_sample/app/core/models/user.model.dart';
import 'package:v_platform/v_platform.dart';

class ProductModel {
  final UserModel userModel;
  final String productId;
  String desc;
  String title;
  int price;
  String imageUrl;
  final DateTime createdAt;

//<editor-fold desc="Data Methods">

  ProductModel({
    required this.productId,
    required this.userModel,
    required this.desc,
    required this.price,
    required this.createdAt,
    required this.imageUrl,
    required this.title,
  });

  VPlatformFile get imgAsPlatformSource => VPlatformFile.fromUrl(
        fileSize: 0,
        url: imageUrl,
      );

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'user': userModel.toMap(),
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'desc': desc,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['productId'] as String,
      userModel: UserModel.fromMap(map['user']),
      desc: map['desc'] as String,
      price: map['price'] as int,
      createdAt: DateTime.parse(map['createdAt']),
      imageUrl: map['imageUrl'] as String,
      title: map['title'] as String,
    );
  }

//</editor-fold>
}
