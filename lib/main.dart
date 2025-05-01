import 'package:flutter/material.dart';
import 'package:unviersty_system/core/storage/storage.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/page_routes_name.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouts.onGenratedRoute,

    );
  }
}