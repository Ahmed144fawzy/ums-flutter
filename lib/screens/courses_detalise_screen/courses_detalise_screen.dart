import 'package:flutter/material.dart';
import 'package:unviersty_system/screens/courses_detalise_screen/quizzes_screen.dart';

import '../../core/colors/app_colors.dart';
import '../../core/icons/app_icons.dart';
import '../../core/widget/custom_bottom_nav_bar.dart';
import 'announcements_screen.dart';
import 'assignments_screen.dart';
import 'materials_screen.dart';

class CoursesDetaliseScreen extends StatefulWidget {
  final String crn; // استقبال رقم CRN من الشاشة السابقة

  const CoursesDetaliseScreen({
    super.key,
    required this.crn,
  });

  @override
  State<CoursesDetaliseScreen> createState() => _CoursesDetaliseScreenState();
}

class _CoursesDetaliseScreenState extends State<CoursesDetaliseScreen> {
  int selectedIndex = 0;
  late List<Widget> screensCourses;

  @override
  void initState() {
    super.initState();
    // تمرير CRN لشاشة المواد فقط، والباقي ثابت
    screensCourses = [
      MaterialsScreen(crn: widget.crn),
      AssignmentsScreen(crn: widget.crn),
      const QuizzesScreen(),
      AnnouncementsScreen(crn: widget.crn),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Course Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: screensCourses[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: const IconThemeData(color: AppColors.orange),
        unselectedIconTheme: const IconThemeData(color: AppColors.grey),
        selectedItemColor: AppColors.orange,
        unselectedItemColor: AppColors.darkGrey,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: "Janna",
          fontWeight: FontWeight.bold,
        ),
        items: [
          BottomNavigationBarItem(
            icon: CustomBottomNavBar(
              iconPath: AppIcons.materialsIcon,
              isSelected: selectedIndex == 0,
            ),
            label: "Materials",
          ),
          BottomNavigationBarItem(
            icon: CustomBottomNavBar(
              iconPath: AppIcons.assignBookIcon,
              isSelected: selectedIndex == 1,
            ),
            label: "Assignments",
          ),
          BottomNavigationBarItem(
            icon: CustomBottomNavBar(
              iconPath: AppIcons.quizIcon,
              isSelected: selectedIndex == 2,
            ),
            label: "Quizzes",
          ),
          BottomNavigationBarItem(
            icon: CustomBottomNavBar(
              iconPath: AppIcons.announcementsIcon,
              isSelected: selectedIndex == 3,
            ),
            label: "Announcements",
          ),
        ],
      ),
    );
  }
}
