class MSignUpUser {
  final String email;
  final String cin;
  final int age;
  final String salary;
  final String password;

  MSignUpUser({
    required this.email,
    required this.cin,
    required this.age,
    required this.salary,
    required this.password,
  });

  factory MSignUpUser.fromMap(Map<String, dynamic> map) {
    return MSignUpUser(
      email: map['email'],
      cin: map ['map'],
      age: map ['age'],
      salary: map ['salary'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'cin': cin,
      'age': age,
      'salary': salary,
      'password': password,
    };
  }
}
