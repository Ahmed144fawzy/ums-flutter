import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/courses_detalise_screen/announcement_item.dart';
import '../../screens/courses_detalise_screen/assginment_item.dart';
import '../../screens/courses_detalise_screen/material_item.dart';
import '../../screens/home_screen2/assignment.dart';
import '../../screens/news_screen/news_item.dart';
import '../routes/page_routes_name.dart';
import '../storage/storage.dart';
import 'package:unviersty_system/screens/news_screen/news_item.dart' as model;


const String baseAPI = "http://172.20.10.8:8000/";
var client = http.Client();

Future<void> login({
  required String studentID,
  required String password,
  required BuildContext context,
}) async { try {
    var response = await client.post(
      Uri.parse("${baseAPI}api/login/student"),
      body: {
        "studentID": studentID,
        "password": password,
      },
    );
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      print("✅ Login Success");
      print(decodedResponse);

      final token = decodedResponse["token"];
      final student = decodedResponse["student"];
      final studentID = student["studentID"].toString();
      final studentName = student["name"];

      // حفظ البيانات الأساسية
      await writeStorage(key: "student_token", value: token);
      await writeStorage(key: "student_id", value: studentID);
      await writeStorage(key: "student_name", value: studentName);

      // نداء API لجلب بيانات إضافية
      await getStudentInfo(token: token, studentId: studentID);

      // الانتقال إلى الشاشة الرئيسية
      Navigator.pushReplacementNamed(context, PageRoutesName.homeScreen);
    } else {
      print("❌ Failed to log in. Status: ${response.statusCode}");
    }
  } catch (e) {
    print("❌ Error during login: $e");
  }
}

Future<void> logout({required String token, required BuildContext context}) async {
  try {
    var response = await client.post(
      Uri.parse("${baseAPI}api/logout"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    if (response.statusCode == 200) {
      print("Logout Success");
      print(decodedResponse);

      await storage.delete(key: "token");

      final checkToken = await storage.read(key: "token");
      print("Token after deletion: $checkToken");

      Navigator.pushReplacementNamed(context, PageRoutesName.loginScreen);
    } else {
      print("Logout failed with status: ${response.statusCode}");
    }
  } catch (e) {
    print("Error during logout: $e");
  } finally {
  }
}

Future<void> getStudentInfo({required String token, required String studentId}) async {
  try {
    var response = await client.get(
      Uri.parse("${baseAPI}api/student-info/$studentId"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      print("📦 API Response: $decodedResponse");

      // Accessing data directly from the response
      final studentID = decodedResponse["studentID"].toString();
      final studentName = decodedResponse["name"];
      final studentEmail = decodedResponse["email"];
      final studentPhone = decodedResponse["phone"];
      final studentLevel = decodedResponse["level"];
      final studentDepartment = decodedResponse["department_name"];

      // Save the data to SharedPreferences
      await writeStorage(key: "student_name", value: studentName);
      await writeStorage(key: "student_id", value: studentID);
      await writeStorage(key: "student_email", value: studentEmail);
      await writeStorage(key: "student_mobile", value: studentPhone);
      await writeStorage(key: "student_level", value: studentLevel);
      await writeStorage(key: "student_department", value: studentDepartment);

      print("Student info saved successfully.");
    } else {
      print("❌ Failed to load student info. Status: ${response.statusCode}");
    }
  } catch (e) {
    print("❌ Exception while loading student info: $e");
  }
}


Future<void> changePassword({
  required String studentID,
  required String currentPassword,
  required String newPassword,
  required String retypeNewPassword,
  required BuildContext context,
}) async {
  final url = Uri.parse("${baseAPI}api/change-password");

  try {
    // نحاول نقرأ التوكن
    final String? token = await readStorage(key: 'student_token');
    debugPrint("✅ TOKEN VALUE: $token");

    if (token == null || token.isEmpty) {
      debugPrint("⚠️ Token is null or empty");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ You are not logged in. Please login again.")),
      );
      return;
    }

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'studentID': studentID,
        'current_password': currentPassword,
        'new_password': newPassword,
        'retype_new_password': retypeNewPassword,
      }),
    );

    debugPrint("🔁 Response body: ${response.body}");

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Password changed successfully.")),
      );
      Navigator.pushReplacementNamed(context, PageRoutesName.homeScreen);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ ${responseData['message'] ?? 'Something went wrong.'}")),
      );
    }
  } catch (e) {
    debugPrint("❌ Error while changing password: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Failed to change password: $e")),
    );
  }
}

Future<List<StudentNewsItem>> fetchNews() async {
  final response = await http.get(Uri.parse('${baseAPI}api/getnews/all/students'));

  if (response.statusCode == 200) {
    final List decoded = jsonDecode(response.body);
    return decoded.map((json) => StudentNewsItem.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load news');
  }
}

Future<List<dynamic>> getCourses(String studentId) async {
  final url = Uri.parse("${baseAPI}api/student/$studentId/courses/all");

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      debugPrint("❌ Failed to fetch courses: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    debugPrint("❌ Error fetching courses: $e");
    return [];
  }
}

Future<List<Map<String, dynamic>>> getLatestCourses(String studentId) async {
  try {
    final response = await http.get(
      Uri.parse("${baseAPI}api/student/$studentId/courses/latest"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      debugPrint("❌ Failed to fetch latest courses: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    debugPrint("❌ Error in getLatestCourses: $e");
    return [];
  }
}
Future<List<model.StudentNewsItem>> latestNews() async {
  final response = await http.get(Uri.parse('${baseAPI}api/getnews/latest/students'));

  if (response.statusCode == 200) {
    final List jsonData = jsonDecode(response.body);
    return jsonData.map((item) => model.StudentNewsItem.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load news');
  }
}
Future<List<MaterialItem>> getMaterialsByCRN(String crn) async {
  try {
    final response = await http.get(Uri.parse('${baseAPI}api/materials/$crn'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => MaterialItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load materials');
    }
  } catch (e) {
    throw Exception('Error fetching materials: $e');
  }
}
Future<List<AssignmentItem>> getAssignmentsByCRN(String crn) async {
  final response = await http.get(Uri.parse("${baseAPI}api/course/$crn/assignments"));

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.map((json) => AssignmentItem.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load assignments");
  }
}

Future<List<Assignment>> getUpcomingAssignments() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final url = Uri.parse('${baseAPI}api/assignments/upcoming');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Assignment.fromJson(json)).toList();
  }

  return [];
}

Future<List<AnnouncementItem>> getAnnouncements(String crn) async {
  final url = Uri.parse("${baseAPI}api/courses/$crn/announcements");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => AnnouncementItem.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load announcements");
  }
}
