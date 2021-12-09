class User {
  final String id;
  final String imageThumb;
  final String email;
  final String name;
  final String accessToken;
  final bool isSelected;

//<editor-fold desc="Data Methods">

  const User({
    required this.id,
    required this.imageThumb,
    required this.email,
    required this.name,
    required this.accessToken,
    required this.isSelected,
  });

  @override
  String toString() {
    return 'User{'
        ' id: $id,'
        ' imageThumb: $imageThumb,'
        ' email: $email,'
        ' name: $name,'
        ' accessToken: $accessToken,'
        ' isSelect: $isSelected,'
        '}';
  }

  User copyWith({
    String? id,
    String? imageThumb,
    String? email,
    String? name,
    String? accessToken,
    bool? isSelected,
  }) {
    return User(
      id: id ?? this.id,
      imageThumb: imageThumb ?? this.imageThumb,
      email: email ?? this.email,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'imageThumb': imageThumb,
      'email': email,
      'name': name,
      'isSelected': isSelected,
      'accessToken': accessToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String,
      imageThumb: map['imageThumb'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      isSelected: false,
      accessToken: map['accessToken'] ?? "",
    );
  }

//</editor-fold>
}
