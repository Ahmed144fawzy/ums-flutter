import 'package:flutter/material.dart';
import 'package:unviersty_system/core/colors/app_colors.dart';
import '../../core/icons/app_icons.dart';
import '../../core/routes/page_routes_name.dart';
import '../../core/storage/storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String studentName = "";
  String studentID = "";
  String studentEmail = "";
  String studentMobile = "";
  String studentLevel = "";
  String studentDepartment = "";

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {

    final name = await readStorage(key: "student_name");
    final id = await readStorage(key: "student_id");
    final email = await readStorage(key: "student_email");
    final mobile = await readStorage(key: "student_mobile");
    final level = await readStorage(key: "student_level");
    final department = await readStorage(key: "student_department");

    print("Email: $email, Mobile: $mobile, Level: $level, Dept: $department");
    setState(() {
      studentName = name ?? "No Name";
      studentID = id ?? "No ID";
      studentEmail = email ?? "No Email";
      studentMobile = mobile ?? "No Mobile";
      studentLevel = level ?? "N/A";
      studentDepartment = department ?? "N/A";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Janna",
                      color: AppColors.black,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, PageRoutesName.settingsScreen);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const ImageIcon(AssetImage(AppIcons.settingsIcon)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                backgroundColor: AppColors.orange,
                radius: 75,
                child: Text(
                  studentName.isNotEmpty ? studentName.substring(0, 2).toUpperCase() : "",
                  style: const TextStyle(
                    fontFamily: "Janna",
                    fontWeight: FontWeight.w600,
                    fontSize: 36,
                    color: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                studentName,
                style: const TextStyle(
                  fontFamily: "Janna",
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: AppColors.black,
                ),
              ),
              const Text(
                "Student",
                style: TextStyle(
                  fontFamily: "Janna",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Student information",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Janna",
                        color: AppColors.orange,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow("Level", studentLevel),
                    _buildInfoRow("Student ID", studentID),
                    _buildInfoRow("Department", studentDepartment),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 0.5, color: AppColors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Personal Information",
                      style: TextStyle(
                        fontFamily: "Janna",
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: AppColors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetail("Name", studentName),
                    _buildDetail("Email", studentEmail),
                    _buildDetail("Mobile", studentMobile),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            "$title:",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: "Janna",
              color: AppColors.white,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: "Janna",
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Janna",
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: "Janna",
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
