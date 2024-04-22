class MSignUpUser {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  MSignUpUser({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}
