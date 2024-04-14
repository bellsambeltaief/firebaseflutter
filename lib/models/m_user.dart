class MUser {
  final int id;
  final String firstName;
  final String lastName;
  final String salary;
  final int age;
  final String maritalStatus;
  final String employment;

  MUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.salary,
    required this.age,
    required this.maritalStatus,
    required this.employment,
  });

  factory MUser.fromMap(Map<String, dynamic> data) {
    return MUser(
      id: data['id'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      salary: data['salary'],
      age: data['age'],
      maritalStatus: data['marital_status'],
      employment: data['employment'],
    );
  }

  Map<String, dynamic> toMap(MUser model) {
    return {
      'id': model.id,
      'first_name': model.firstName,
      'last_name': model.lastName,
      'salary': model.salary,
      'age': model.age,
      'marital_status': model.maritalStatus,
      'employment': model.employment,
    };
  }
}
