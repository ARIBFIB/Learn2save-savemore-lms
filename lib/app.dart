import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'routes/app_routes.dart';
import 'routes/route_generator.dart';
import 'constants/colors.dart';
import 'views/mobile/login_screen.dart';
import 'views/web/login_web.dart';

class LMSApp extends StatelessWidget {
  const LMSApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Savemore LMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppColors.primaryMaterialColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
      ),
      initialRoute: AppRoutes.login,
      onGenerateRoute: RouteGenerator.generateRoute,
      // For demonstration, we're using conditional rendering based on platform
      // In a real app, this would be handled by the route generator
      home: kIsWeb ? const LoginWebScreen() : const LoginScreen(),
    );
  }
}