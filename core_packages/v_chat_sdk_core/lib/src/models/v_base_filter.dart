class VBaseFilter {
    int? limit;
    int? page;
    String? name;

//<editor-fold desc="Data Methods">
  VBaseFilter({
    this.limit,
    this.page,
    this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VBaseFilter &&
          runtimeType == other.runtimeType &&
          limit == other.limit &&
          page == other.page &&
          name == other.name);

  @override
  int get hashCode => limit.hashCode ^ page.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'VBaseFilter{' +
        ' limit: $limit,' +
        ' page: $page,' +
        ' name: $name,' +
        '}';
  }

  VBaseFilter copyWith({
    int? limit,
    int? page,
    String? name,
  }) {
    return VBaseFilter(
      limit: limit ?? this.limit,
      page: page ?? this.page,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'limit': this.limit,
      'page': this.page,
      'name': this.name,
    };
  }

  factory VBaseFilter.fromMap(Map<String, dynamic> map) {
    return VBaseFilter(
      limit: map['limit'] as int,
      page: map['page'] as int,
      name: map['name'] as String,
    );
  }

//</editor-fold>
}
