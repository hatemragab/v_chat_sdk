class WebMetadata {
  final String url;
  final String title;
  final String? description;
  final List<String> images;
  final List<String> favicons;

//<editor-fold desc="Data Methods">
  const WebMetadata({
    required this.url,
    required this.title,
    this.description,
    required this.images,
    required this.favicons,
  });

  @override
  String toString() {
    return 'WebMetadata{ url: $url, title: $title, description: $description, images: $images, favicons: $favicons,}';
  }

  WebMetadata copyWith({
    String? url,
    String? title,
    String? description,
    List<String>? images,
    List<String>? favicons,
  }) {
    return WebMetadata(
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      favicons: favicons ?? this.favicons,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'title': title,
      'description': description,
      'images': images,
      'favicons': favicons,
    };
  }

  factory WebMetadata.fromMap(Map<String, dynamic> map) {
    return WebMetadata(
      url: (map['url'] as String?) ?? "URL NOT FOUND",
      title: (map['title'] as String?) ?? "TITLE NOT FOUND",
      description: map['description'] as String?,
      images: map['images'] == null
          ? []
          : (map['images'] as List).map((e) => e.toString()).toList(),
      favicons: map['favicons'] == null
          ? []
          : (map['favicons'] as List).map((e) => e.toString()).toList(),
    );
  }

//</editor-fold>
}
