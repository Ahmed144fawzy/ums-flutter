import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unviersty_system/core/storage/storage.dart';
import '../../core/images/app_images.dart';
import '../../core/routes/page_routes_name.dart';
class SplashScreen extends StatefulWidget {
  static const routeName = "/splash_view";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2));

    final token = await readStorage(key: "token");
    print("TOKEN IN SPLASH: $token");

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, PageRoutesName.homeScreen);
    } else {
      Navigator.pushReplacementNamed(context, PageRoutesName.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.splashLogo,
              height: mediaQuery.height * 0.24,
            ),
          ],
        ),
      ),
    );
  }
}
