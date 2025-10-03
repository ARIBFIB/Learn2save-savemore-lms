import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../views/mobile/login_screen.dart';
import '../views/mobile/signup_screen.dart';
import '../views/mobile/dashboard_screen.dart';
import '../views/mobile/course_detail_screen.dart';
import '../views/web/login_web.dart';
import '../views/web/signup_web.dart';
import '../views/web/dashboard_web.dart';
import '../views/web/course_detail_web.dart';
import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final routeName = settings.name;
    // final arguments = settings.arguments; // You don't need this variable here

    switch (routeName) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => kIsWeb ? const LoginWebScreen() : const LoginScreen(),
          settings: settings,
        );

      case AppRoutes.signup:
        return MaterialPageRoute(
          builder: (_) => kIsWeb ? const SignupWebScreen() : const SignupScreen(),
          settings: settings,
        );

      case AppRoutes.dashboard:
        return MaterialPageRoute(
          builder: (_) => kIsWeb ? const DashboardWebScreen() : const DashboardScreen(),
          settings: settings,
        );

      case AppRoutes.courseDetail:
      // FIX: Build the widget without passing arguments to the constructor.
      // The widget will fetch the arguments from the route settings itself.
      // This makes the mobile and web behavior consistent.
        return MaterialPageRoute(
          builder: (_) => kIsWeb
              ? const CourseDetailWebScreen(courseId: '1',) // FIX: Removed hardcoded argument
              : const CourseDetailScreen(),
          settings: settings, // Pass the settings so the widget can access arguments
        );

      default:
        return _errorRoute('Route not found');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}