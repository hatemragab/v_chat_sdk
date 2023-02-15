// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class CurrentRoom {
  bool isActive;
  String roomId;

  CurrentRoom({
    required this.isActive,
    required this.roomId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentRoom &&
          runtimeType == other.runtimeType &&
          roomId == other.roomId;

  @override
  int get hashCode => roomId.hashCode;
}
