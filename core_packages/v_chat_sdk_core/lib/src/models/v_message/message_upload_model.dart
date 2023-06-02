// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;

/// A model that represents a message upload.
class VMessageUploadModel {
  /// The body of the message.
  final List<PartValue> body;

  /// The first file associated with the message, if applicable.
  final http.MultipartFile? file1;

  /// The second file associated with the message, if applicable.
  final http.MultipartFile? file2;

  /// The ID of the room where the message is being sent.
  final String roomId;

  /// The local ID of the message.
  final String msgLocalId;

  /// Constructs a new `VMessageUploadModel` instance.
  ///
  /// [body] is the body of the message.
  /// [roomId] is the ID of the room where the message is being sent.
  /// [msgLocalId] is the local ID of the message.
  /// [file1] is the first file associated with the message, if applicable.
  /// [file2] is the second file associated with the message, if applicable.
  const VMessageUploadModel({
    required this.body,
    required this.roomId,
    required this.msgLocalId,
    this.file1,
    this.file2,
  });

  /// Overrides the equality operator for better comparison capabilities.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VMessageUploadModel &&
          runtimeType == other.runtimeType &&
          msgLocalId == other.msgLocalId;

  /// Generates a hashcode based on the message's local ID.
  @override
  int get hashCode => msgLocalId.hashCode;

  /// Returns a copy of this `VMessageUploadModel` but with the
  /// given fields replaced with the new values.
  VMessageUploadModel copyWith({
    List<PartValue>? body,
    http.MultipartFile? file1,
    http.MultipartFile? file2,
    String? roomId,
    String? msgLocalId,
  }) {
    return VMessageUploadModel(
      body: body ?? this.body,
      file1: file1 ?? this.file1,
      file2: file2 ?? this.file2,
      roomId: roomId ?? this.roomId,
      msgLocalId: msgLocalId ?? this.msgLocalId,
    );
  }
}
