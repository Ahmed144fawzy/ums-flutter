import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unviersty_system/core/colors/app_colors.dart';
import 'package:unviersty_system/core/icons/app_icons.dart';
import 'package:unviersty_system/core/images/app_images.dart';
import 'package:unviersty_system/core/routes/page_routes_name.dart';
import 'package:unviersty_system/core/widget/assignments_due.dart';
import 'package:unviersty_system/core/widget/courses_items.dart';
import 'package:unviersty_system/core/widget/posts_news.dart';
import '../../core/network/login.dart';
import '../../core/storage/storage.dart';
import 'package:unviersty_system/core/network/login.dart' as api;
import 'package:unviersty_system/screens/news_screen/news_item.dart' as model;

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  List<Map<String, dynamic>> latestCourses = [];
  List<model.StudentNewsItem> news = [];
  List<Map<String, dynamic>> assignments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadLatestCourses();
    fetchNews();
    fetchAssignments();
  }

  Future<void> loadLatestCourses() async {
    final studentId = await readStorage(key: 'student_id');
    if (studentId != null) {
      final courses = await getLatestCourses(studentId);
      setState(() {
        latestCourses = courses;
      });
    }
  }

  Future<void> fetchNews() async {
    try {
      final data = await api.latestNews();
      setState(() {
        news = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching news: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAssignments() async {
    try {
      final studentId = await readStorage(key: 'student_id');

      if (studentId == null) {
        print("❌ studentId is null");
        return;
      }

      final courses = await getLatestCourses(studentId);

      if (courses.isNotEmpty && courses.first['CRN'] != null) {
        final crn = courses.first['CRN'].toString();
        final url = Uri.parse("${baseAPI}api/course/$crn/assignments");
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          setState(() {
            assignments = data.cast<Map<String, dynamic>>();
          });
        } else {
          print("❌ Failed to load assignments. Status code: ${response.statusCode}");
        }
      } else {
        print("❌ No courses available or CRN is null.");
      }
    } catch (e) {
      print("❌ Error fetching assignments: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AppImages.splashLogo, width: 80, height: 80),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back @user! 👋",
                          style: TextStyle(
                            fontFamily: "Janna",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blue,
                          ),
                        ),
                        Text(
                          "How Are You Today?",
                          style: TextStyle(
                            fontFamily: "Janna",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PageRoutesName.notificationScreen);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const ImageIcon(AssetImage(AppIcons.notfiIcon)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Courses Section
                Row(
                  children: [
                    const Text(
                      "Latest Courses Activities",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        fontFamily: "Janna",
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, PageRoutesName.coursesScreen);
                      },
                      child: const Text(
                        "See All",
                        style: TextStyle(
                          color: AppColors.grey,
                          fontFamily: "Janna",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 535,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: latestCourses.length,
                    itemBuilder: (context, index) {
                      final course = latestCourses[index];
                      return SizedBox(
                        height: 160,
                        width: 360,
                        child: CoursesItems(
                          courseName: course['course_name'],
                          crn: course['CRN'].toString(),
                          professor: course['professor_name'],
                          studentCount: "${course['number_of_students']} Students",
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                  ),
                ),

                const SizedBox(height: 24),
                // Assignments Section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Assignments Due",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Janna",
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 398,
                  child: assignments.isEmpty
                      ? const Center(child: Text("No assignments due"))
                      : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: assignments.length,
                    itemBuilder: (context, index) {
                      final item = assignments[index];
                      return SizedBox(
                        height: 100,
                        child: AssignmentsDue(
                          title: item['title'] ?? 'No Title',
                          description: item['description'] ?? 'No Description',
                          deadline: item['deadline'] ?? '',
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                  ),
                ),

                const SizedBox(height: 24),

                // News Section
                Row(
                  children: [
                    const Text(
                      "Latest News",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Janna",
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, PageRoutesName.newsScreen);
                      },
                      child: const Text(
                        "See All",
                        style: TextStyle(
                          color: AppColors.grey,
                          fontFamily: "Janna",
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                  height: 440,
                  width: double.infinity,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      final item = news[index];
                      return PostsNews(
                        title: item.content,
                        description: item.filePath,
                        date: item.createdAt.toString(),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
