// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:v_platform/v_platform.dart';

/// `CreateBroadcastDto` is a Data Transfer Object (DTO) class for sending
/// broadcast creation data to the API.
class CreateBroadcastDto {
  /// A list of unique identifiers. These could be user identifiers who are
  /// intended to be the participants of the broadcast.
  final List<String> identifiers;

  /// The title or name of the broadcast to be created.
  final String title;

  /// An optional `VPlatformFile` that represents an image associated with
  /// the broadcast. This could be a logo or banner for the broadcast.
  final VPlatformFile? platformImage;

  /// A constructor to create an instance of `CreateBroadcastDto`.
  ///
  /// Requires [identifiers] and [title] to be non-null, while [platformImage]
  /// is optional.
  const CreateBroadcastDto({
    required this.identifiers,
    required this.title,
    this.platformImage,
  });

  /// Converts the object properties to a list of `PartValue` objects.
  ///
  /// `PartValue` is a pair of a string key and its associated value, used for
  /// data transfer.
  ///
  /// Returns a list of `PartValue` objects containing the identifiers and
  /// broadcast name.
  List<PartValue> toListOfPartValue() {
    return [
      PartValue('identifiers', jsonEncode(identifiers)),
      PartValue("broadcastName", title),
    ];
  }
}
