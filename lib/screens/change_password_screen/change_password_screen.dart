import 'package:flutter/material.dart';
import 'package:unviersty_system/core/colors/app_colors.dart';
import 'package:unviersty_system/core/widget/custom_text_field.dart';

import '../../core/network/login.dart';
import '../../core/storage/storage.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _retypeNewPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _handleChangePassword() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // استرجاع studentID من التخزين
    String? studentID = await readStorage(key: 'student_id');

    if (studentID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ No student ID found. Please login again.")),
      );
      setState(() => _isLoading = false);
      return;
    }

    await changePassword(
      studentID: studentID,
      currentPassword: _oldPasswordController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
      retypeNewPassword: _retypeNewPasswordController.text.trim(),
      context: context,

    );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change password",
          style: TextStyle(
            fontFamily: "Janna",
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: AppColors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildLabel("Current Password"),
                  buildTextField(_oldPasswordController, "Please enter your old password"),
                  SizedBox(height: mediaQuery.height * 0.02),
                  buildLabel("New Password"),
                  buildTextField(_newPasswordController, "Please enter your new password"),
                  SizedBox(height: mediaQuery.height * 0.02),
                  buildLabel("Retype Password"),
                  CustomTextField(
                    controller: _retypeNewPasswordController,
                    onValidate: (value) {
                      if (value!.isEmpty) return 'Please retype your new password';
                      if (value != _newPasswordController.text) return 'Passwords do not match';
                      return null;
                    },
                    isPassword: true,
                    maxLines: 1,
                    hint: "Please retype your password",
                    hintColor: AppColors.darkGrey,
                  ),
                  SizedBox(height: mediaQuery.height * 0.35),
                  Container(height: 1, width: double.infinity, color: Colors.grey),
                  SizedBox(height: mediaQuery.height * 0.02),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading ? null : _handleChangePassword,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "Change Password",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 16,
          color: AppColors.black,
          fontFamily: "Janna",
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hint) {
    return Column(
      children: [
        SizedBox(height: 8),
        CustomTextField(
          controller: controller,
          onValidate: (value) {
            if (value == null || value.trim().isEmpty) {
              return "This field cannot be empty";
            }
            return null;
          },
          isPassword: true,
          maxLines: 1,
          hint: hint,
          hintColor: AppColors.darkGrey,
        ),
      ],
    );
  }
}
