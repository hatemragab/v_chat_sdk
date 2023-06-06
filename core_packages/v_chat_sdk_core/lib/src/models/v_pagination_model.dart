// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class VPaginationModel<T> {
  List<T> data;
  int page;
  int limit;
  int? nextPage;

//<editor-fold desc="Data Methods">

  VPaginationModel({
    required this.data,
    required this.page,
    required this.limit,
    this.nextPage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VPaginationModel &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          page == other.page &&
          limit == other.limit &&
          nextPage == other.nextPage);

  @override
  int get hashCode =>
      data.hashCode ^ page.hashCode ^ limit.hashCode ^ nextPage.hashCode;

  @override
  String toString() {
    return 'PaginationModel{ values: $data, page: $page, limit: $limit, nextPage: $nextPage,}';
  }

  VPaginationModel copyWith({
    List<T>? values,
    int? page,
    int? limit,
    int? nextPage,
  }) {
    return VPaginationModel(
      data: values ?? this.data,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      nextPage: nextPage ?? this.nextPage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'limit': limit,
    };
  }

  // factory VPaginationModel.fromMap(Map<String, dynamic> map) {
  //   return VPaginationModel(
  //     values: List<T>.from(map['docs'] as List),
  //     page: map['page'] as int,
  //     limit: map['limit'] as int,
  //     nextPage: map['nextPage'] as int?,
  //   );
  // }

  factory VPaginationModel.fromCustomMap({
    required List<T> values,
    required Map<String, dynamic> map,
  }) {
    return VPaginationModel(
      data: values,
      page: map['page'] as int,
      limit: map['limit'] as int,
      nextPage: map['nextPage'] as int?,
    );
  }

//</editor-fold>
}
