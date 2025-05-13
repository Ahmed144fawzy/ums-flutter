import 'package:flutter/material.dart';
import 'package:unviersty_system/core/widget/courses_items.dart';
import '../../core/colors/app_colors.dart';
import '../../core/icons/app_icons.dart';
import '../../core/network/login.dart';
import '../../core/widget/custom_text_field.dart';

import '../../core/storage/storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<dynamic> courses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    final studentId = await readStorage(key: 'student_id');
    if (studentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ No student ID found.")),
      );
      setState(() => isLoading = false);
      return;
    }

    final data = await getCourses(studentId);
    setState(() {
      courses = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 255,
              decoration: const BoxDecoration(
                color: AppColors.orange,
                borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: const SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        "Courses",
                        style: TextStyle(
                          fontFamily: "Janna",
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: AppColors.blue,
                        ),
                      ),
                      Text(
                        "Access your registered courses, materials, \nand assignments",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Janna",
                        ),
                      ),
                      SizedBox(height: 24),
                      CustomTextField(
                        textStyle: TextStyle(
                          fontFamily: "Janna",
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        hintColor: AppColors.grey,
                        hint: "Search",
                        prefixIcon: ImageIcon(
                          AssetImage(AppIcons.searchIcon),
                          size: 18,
                          color: AppColors.blue,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return CoursesItems(
                  courseName: course['course_name'],
                  crn: course['CRN'].toString(),
                  professor: course['professor_name'],
                  studentCount:
                  course['number_of_students'].toString(),
                );
              },
              separatorBuilder: (context, index) =>
              const SizedBox(height: 16),
            ),
          ],
        ),
      ),
    );
  }
}
