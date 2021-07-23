class User {
  final int id;
  final String name;
  final String email;
  String? token;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
  });

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email}';
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      token: map['token'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
