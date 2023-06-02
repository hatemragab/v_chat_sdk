// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

/// Model class for single block in a chat room for blocking a user.
class VSingleBlockModel {
  /// True if the banner belongs to the current user, false otherwise.
  final bool isMeBanner;

  /// True if the banner belongs to the peer user, false otherwise.
  final bool isPeerBanner;

  /// The ID of the chat room where the block occurs.
  final String roomId;

  /// Creates a new [VSingleBlockModel] instance.
  const VSingleBlockModel({
    required this.isMeBanner,
    required this.isPeerBanner,
    required this.roomId,
  });

  /// Returns true if there is a banner.
  bool get isThereBan => isMeBanner == true || isPeerBanner == true;

  /// Returns a string representation of the [VSingleBlockModel] instance.
  @override
  String toString() {
    return 'VSingleBlockModel{isMeBanner: $isMeBanner, isPeerBanner: $isPeerBanner, roomId: $roomId}';
  }

  /// Returns a map representation of the [VSingleBlockModel] instance.
  Map<String, dynamic> toMap() {
    return {
      'isMeBanner': isMeBanner,
      'isPeerBanner': isPeerBanner,
      'roomId': roomId,
    };
  }

  /// Creates a [VSingleBlockModel] instance from a map object.
  factory VSingleBlockModel.fromMap(Map<String, dynamic> map) {
    return VSingleBlockModel(
      isMeBanner: map['isMeBanner'] as bool,
      isPeerBanner: map['isPeerBanner'] as bool,
      roomId: (map['roomId'] as String?) ?? "",
    );
  }
}
