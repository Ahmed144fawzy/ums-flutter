class AssignmentItem {
  final int id;
  final String title;
  final String description;
  final String deadline;


  AssignmentItem({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
  });

  factory AssignmentItem.fromJson(Map<String, dynamic> json) {
    return AssignmentItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      deadline: json['deadline'],
    );
  }
}
