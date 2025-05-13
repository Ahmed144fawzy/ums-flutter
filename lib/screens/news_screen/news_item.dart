class StudentNewsItem {
  final String content;
  final String filePath;
  final DateTime createdAt;

  StudentNewsItem({
    required this.content,
    required this.filePath,
    required this.createdAt,
  });

  factory StudentNewsItem.fromJson(Map<String, dynamic> json) {
    return StudentNewsItem(
      content: json['content'] ?? '',
      filePath: json['file_path'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}