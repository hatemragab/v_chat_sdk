// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class VRoomsDto {
  const VRoomsDto({
    this.limit = 20,
    this.page = 1,
    this.title,
  });

  final int limit;
  final int page;
  final String? title;

  Map<String, dynamic> toMap() {
    return {
      'limit': limit,
      'page': page,
      'fullNameEn': title,
    };
  }
}
