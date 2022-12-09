class VPaginationModel<T> {
  final List<T> values;
  int page;
  int limit;
  int? nextPage;

//<editor-fold desc="Data Methods">

  VPaginationModel({
    required this.values,
    required this.page,
    required this.limit,
    this.nextPage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VPaginationModel &&
          runtimeType == other.runtimeType &&
          values == other.values &&
          page == other.page &&
          limit == other.limit &&
          nextPage == other.nextPage);

  @override
  int get hashCode =>
      values.hashCode ^ page.hashCode ^ limit.hashCode ^ nextPage.hashCode;

  @override
  String toString() {
    return 'PaginationModel{' +
        ' values: $values,' +
        ' page: $page,' +
        ' limit: $limit,' +
        ' nextPage: $nextPage,' +
        '}';
  }

  VPaginationModel copyWith({
    List<T>? values,
    int? page,
    int? limit,
    int? nextPage,
  }) {
    return VPaginationModel(
      values: values ?? this.values,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      nextPage: nextPage ?? this.nextPage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'values': this.values,
      'page': this.page,
      'limit': this.limit,
      'nextPage': this.nextPage,
    };
  }

  factory VPaginationModel.fromMap(Map<String, dynamic> map) {
    return VPaginationModel(
      values: List<T>.from(map['values'] as List),
      page: map['page'] as int,
      limit: map['limit'] as int,
      nextPage: map['nextPage'] as int?,
    );
  }

//</editor-fold>
}
