import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'controllers/auth_controller.dart';
import 'controllers/course_controller.dart';
import 'controllers/dashboard_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Shared Preferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController(prefs)),
        ChangeNotifierProvider(create: (_) => CourseController()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
      ],
      child: const LMSApp(),
    ),
  );
}