class Assignment {
  final String name;
  final String deadline;
  final String courseName;
  final int courseCode;

  Assignment({
    required this.name,
    required this.deadline,
    required this.courseName,
    required this.courseCode,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      name: json['name'],
      deadline: json['deadline'],
      courseName: json['course_name'],
      courseCode: json['course_code'],
    );
  }
}
