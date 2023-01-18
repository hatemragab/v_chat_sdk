class UserFilterDto{
    int limit;
    int page;
    String? fullName;

//<editor-fold desc="Data Methods">

    UserFilterDto({
    required this.limit,
    required this.page,
      this.fullName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserFilterDto &&
          runtimeType == other.runtimeType &&
          limit == other.limit &&
          page == other.page &&
          fullName == other.fullName);

  @override
  int get hashCode => limit.hashCode ^ page.hashCode ^ fullName.hashCode;

  @override
  String toString() {
    return 'UserFilterDto{' +
        ' limit: $limit,' +
        ' page: $page,' +
        ' fullName: $fullName,' +
        '}';
  }

  UserFilterDto copyWith({
    int? limit,
    int? page,
    String? fullName,
  }) {
    return UserFilterDto(
      limit: limit ?? this.limit,
      page: page ?? this.page,
      fullName: fullName ?? this.fullName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'limit': this.limit,
      'page': this.page,
      'fullName': this.fullName,
    };
  }

  factory UserFilterDto.fromMap(Map<String, dynamic> map) {
    return UserFilterDto(
      limit: map['limit'] as int,
      page: map['page'] as int,
      fullName: map['fullName'] as String,
    );
  }

//</editor-fold>
}