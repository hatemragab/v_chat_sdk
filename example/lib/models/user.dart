class User {
  final int id;
  final String imageThumb;
  final String email;
  final String name;
  final String accessToken;

//<editor-fold desc="Data Methods">

  const User({
    required this.id,
    required this.imageThumb,
    required this.email,
    required this.name,
    required this.accessToken,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          imageThumb == other.imageThumb &&
          email == other.email &&
          name == other.name &&
          accessToken == other.accessToken);

  @override
  int get hashCode =>
      id.hashCode ^
      imageThumb.hashCode ^
      email.hashCode ^
      name.hashCode ^
      accessToken.hashCode;

  @override
  String toString() {
    return 'User{'
        ' id: $id,'
        ' imageThumb: $imageThumb,'
        ' email: $email,'
        ' name: $name,'
        ' accessToken: $accessToken,'
        '}';
  }

  User copyWith({
    int? id,
    String? imageThumb,
    String? email,
    String? name,
    String? accessToken,
  }) {
    return User(
      id: id ?? this.id,
      imageThumb: imageThumb ?? this.imageThumb,
      email: email ?? this.email,
      name: name ?? this.name,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'imageThumb': imageThumb,
      'email': email,
      'name': name,
      'accessToken': accessToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as int,
      imageThumb: map['imageThumb'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      accessToken: map['accessToken'] ?? "",
    );
  }

//</editor-fold>
}
