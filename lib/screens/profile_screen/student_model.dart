class StudentModel {
  final int studentID;
  final String name;
  final String email;
  final String phone;
  final String level;
  final String departmentName;

  StudentModel({
    required this.studentID,
    required this.name,
    required this.email,
    required this.phone,
    required this.level,
    required this.departmentName,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      studentID: json['studentID'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      level: json['level'].toString(),
      departmentName: json['department_name'],
    );
  }
}
