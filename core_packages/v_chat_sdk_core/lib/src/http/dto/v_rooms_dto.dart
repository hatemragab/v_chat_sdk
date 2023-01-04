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
