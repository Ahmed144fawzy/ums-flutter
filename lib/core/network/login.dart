import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../routes/page_routes_name.dart';
import '../storage/storage.dart';

const String baseAPI = "http://192.168.1.8:8000/";
var client = http.Client();
Future<void> login({
  required String studentID,
  required String password,
  required BuildContext context,
}) async {
  try {
    var response = await client.post(
      Uri.parse("${baseAPI}api/login/student"),
      body: {
        "studentID": studentID,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      print("Success");
      print(decodedResponse);

      final token = decodedResponse["token"];
      final student = decodedResponse["student"];

      // استخراج القيم بشكل آمن
      final studentID = student["studentID"].toString();
      final studentName = student["name"];
      final studentEmail = student["email"] ?? "No Email";
      final studentMobile = student["mobile"] ?? "No Mobile";

      // حفظ البيانات في SharedPreferences
      await writeStorage(key: "student_name", value: studentName);
      await writeStorage(key: "student_id", value: studentID);
      await writeStorage(key: "student_email", value: studentEmail);
      await writeStorage(key: "student_mobile", value: studentMobile);
      await writeStorage(key: "student_token", value: token); // حفظ الـ token إذا كان ضروري

      // بعد تسجيل الدخول، قم بتوجيه المستخدم إلى الشاشة الرئيسية
      Navigator.pushReplacementNamed(context, PageRoutesName.homeScreen);
    } else {
      print("❌ Failed to log in. Status: ${response.statusCode}");
      // يمكن إضافة رسالة خطأ هنا للمستخدم إذا كانت الاستجابة ليست 200
    }
  } catch (e) {
    print("Error: $e");
    // من الأفضل أيضًا إظهار رسالة خطأ للمستخدم في حالة حدوث مشكلة
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

Future<void> getStudentInfo({
  required String token,
  required String studentId,
}) async {
  final url = Uri.parse("${baseAPI}api/student-info/$studentId");

  try {
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    print("📦 API Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      // طباعة للتأكد من القيم الراجعة
      print("✅ Data decoded: $data");

      await writeStorage(key: "student_id", value: data["studentID"].toString());
      await writeStorage(key: "student_name", value: data["name"] ?? "");
      await writeStorage(key: "student_email", value: data["email"] ?? "");
      await writeStorage(key: "student_mobile", value: data["phone"] ?? "");
      await writeStorage(key: "student_level", value: data["level"]?.toString() ?? "");
      await writeStorage(key: "student_department", value: data["department_name"] ?? "");

      print("✅ Student info saved successfully.");
    } else {
      print("❌ Failed to load student info. Status: ${response.statusCode}");
    }
  } catch (e) {
    print("❌ Exception while loading student info: $e");
  }
}



