class MLogin {
  final String email;
  final String password;

  MLogin({
    required this.email,
    required this.password,
  });

  factory MLogin.fromMap(Map<String, dynamic> map) {
    return MLogin(
      email: map['email'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}
