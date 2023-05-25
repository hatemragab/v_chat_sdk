// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class MentionModel {
  final String identifier;
  final String name;
  final String image;

  MentionModel({
    required this.identifier,
    required this.name,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'identifier': identifier,
      'name': name,
      'image': image,
    };
  }

  factory MentionModel.fromMap(Map<String, dynamic> map) {
    return MentionModel(
      identifier: map['identifier'] as String,
      name: map['name'] as String,
      image: map['image'] as String,
    );
  }
}
