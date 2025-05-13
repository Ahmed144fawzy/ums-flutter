class MaterialItem {
  final int id;
  final String title;
  final String description;
  final String filePath;
  final String fileName;
  final int courseId;
  final String createdAt;
  final String updatedAt;
  final int commentsCount;

  MaterialItem({
    required this.id,
    required this.title,
    required this.description,
    required this.filePath,
    required this.fileName,
    required this.courseId,
    required this.createdAt,
    required this.updatedAt,
    required this.commentsCount,
  });

  factory MaterialItem.fromJson(Map<String, dynamic> json) {
    return MaterialItem(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      filePath: json['file_path'] as String,
      fileName: json['file_name'] as String,
      courseId: json['course_id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      commentsCount: json['comments_count'] as int,
    );
  }
}
