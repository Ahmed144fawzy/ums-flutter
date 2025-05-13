import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../colors/app_colors.dart';
import '../icons/app_icons.dart';
import '../images/app_images.dart';

// كائن NewsItem
class NewsItem {
  final String title;
  final String description;
  final String date;

  NewsItem({required this.title, required this.description, required this.date});

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['title'] ?? 'No title',
      description: json['description'] ?? 'No description',
      date: json['date'] ?? 'No date',
    );
  }
}

// دالة لتحميل الأخبار من الـ API
Future<List<NewsItem>> latestNews() async {
  final response = await http.get(Uri.parse('http://yourapi.com/api/getnews/latest/students'));

  if (response.statusCode == 200) {
    final List decoded = jsonDecode(response.body);
    return decoded.map((json) => NewsItem.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load news');
  }
}

// الصفحة التي تعرض الأخبار
class PostsNews extends StatelessWidget {
  final String title;
  final String description;
  final String date;

  const PostsNews({
    super.key,
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 440,
      width: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lightGrey,
                  border: Border.all(color: AppColors.grey, width: 1.5),
                ),
                child: Image.asset(AppIcons.adminsIcon),
              ),
              const SizedBox(width: 11),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, // عرض العنوان
                    style: const TextStyle(
                      fontFamily: "Janna",
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                  ),
                  const Text(
                    "Admin", // يمكن تعديلها حسب بيانات أخرى إذا كانت متوفرة
                    style: TextStyle(
                      fontFamily: "Janna",
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                date, // عرض التاريخ
                style: const TextStyle(
                  fontFamily: "Janna",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description, // عرض الوصف
            style: const TextStyle(
              fontFamily: "Janna",
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          Image.asset(
            AppImages.subjectList, // صورة الخبر
            height: 300,
            width: 232,
          ),
        ],
      ),
    );
  }
}
