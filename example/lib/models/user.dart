class User {
  final String token;
  final String img;
  final String bio;
  final String role;
  final String id;
  final String userName;
  final String email;
  final int created;
  final String authToken;

//<editor-fold desc="Data Methods">

  const User({
    required this.token,
    required this.img,
    required this.bio,
    required this.role,
    required this.id,
    required this.userName,
    required this.email,
    required this.created,
    required this.authToken,
  });

  @override
  String toString() {
    return 'User{' +
        ' token: $token,' +
        ' img: $img,' +
        ' bio: $bio,' +
        ' role: $role,' +
        ' id: $id,' +
        ' userName: $userName,' +
        ' email: $email,' +
        ' created: $created,' +
        ' authToken: $authToken,' +
        '}';
  }

  User copyWith({
    String? token,
    String? img,
    String? bio,
    String? role,
    String? id,
    String? userName,
    String? email,
    int? created,
    String? authToken,
  }) {
    return User(
      token: token ?? this.token,
      img: img ?? this.img,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      created: created ?? this.created,
      authToken: authToken ?? this.authToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': this.token,
      'img': this.img,
      'bio': this.bio,
      'role': this.role,
      '_id': this.id,
      'user_name': this.userName,
      'email': this.email,
      'created': this.created,
      'authToken': this.authToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      token: map['token'] as String,
      img: map['img'] as String,
      bio: map['bio'] as String,
      role: map['role'] as String,
      id: map['_id'] as String,
      userName: map['user_name'] as String,
      email: map['email'] as String,
      created: map['created'] as int,
      authToken: map['authToken'] ?? 'NULLLL',
    );
  }

//</editor-fold>
}
