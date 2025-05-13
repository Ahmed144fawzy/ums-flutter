class AnnouncementItem {
  final int id;
  final String content;
  final String createdAt;
  final String professorName;

  AnnouncementItem({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.professorName,
  });

  factory AnnouncementItem.fromJson(Map<String, dynamic> json) {
    return AnnouncementItem(
      id: json['id'],
      content: json['content'],
      createdAt: json['created_at'],
      professorName: json['professor_name'],
    );
  }
}
