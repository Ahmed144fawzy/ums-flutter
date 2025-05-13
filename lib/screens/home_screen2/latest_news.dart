import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/network/login.dart';

// كائن يمثل الخبر
class NewsItem {
  final String title;
  final String description;
  final String date;

  NewsItem({
    required this.title,
    required this.description,
    required this.date,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['content'] ?? 'No title',
      description: json['file_path'] ?? 'No description',
      date: json['created_at'] ?? 'No date',
    );
  }
}

// دالة لجلب الأخبار الأخيرة من الـ API
Future<List<NewsItem>> latestNews() async {
  final url = Uri.parse('${baseAPI}/api/getnews/latest/students');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List jsonData = jsonDecode(response.body);

      return jsonData.map((item) => NewsItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load news: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching news: $e');
  }
}
