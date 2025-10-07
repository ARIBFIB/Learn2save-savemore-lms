import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn2save_lms_flutter_app/controllers/auth_controller.dart';
import 'package:learn2save_lms_flutter_app/views/mobile/certificates_screen.dart';
import 'package:learn2save_lms_flutter_app/views/mobile/course_content_screen.dart';
import 'package:learn2save_lms_flutter_app/views/mobile/settings_screen.dart';
import 'package:provider/provider.dart';
import 'constants/colors.dart';
import 'constants/strings.dart';
import 'routes/app_routes.dart';
import 'views/mobile/login_screen.dart';
import 'views/web/login_web.dart';
import 'views/mobile/dashboard_screen.dart';
import 'views/web/dashboard_web.dart';
import 'views/mobile/course_list_screen.dart';
import 'views/web/course_list_web.dart';
import 'views/mobile/course_detail_screen.dart';
import 'views/web/course_detail_web.dart';
import 'views/mobile/quiz_screen.dart';
import 'views/web/quiz_web.dart';
import 'views/mobile/profile_screen.dart';
import 'views/web/profile_web.dart';
import 'views/mobile/notifications_screen.dart';
import 'views/web/notifications_web.dart';
import 'views/mobile/signup_screen.dart';
import 'views/web/signup_web.dart';
import 'widgets/side_menu.dart';
import 'widgets/bottom_nav.dart';
// Import new admin screens
import 'views/admin/admin_dashboard.dart';
import 'views/admin/admin_course_management.dart';
// Add these imports to the existing imports in app.dart
import 'views/admin/admin_user_management.dart';
import 'views/admin/admin_quiz_management.dart';
import 'views/admin/admin_analytics.dart';
import 'views/mobile/quiz_result_screen.dart';


class LMSApp extends StatelessWidget {
  const LMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'CenturyGothic',
        primarySwatch: AppColors.primaryMaterial,
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
      ),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    // Authentication Routes
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) {
        final isWeb = MediaQuery.of(context).size.width > 800;
        return isWeb ? const LoginWeb() : const LoginScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) {
        final isWeb = MediaQuery.of(context).size.width > 800;
        return isWeb ? const SignupWeb() : const SignupScreen();
      },
    ),

    // Admin Routes with Shell
    ShellRoute(
      builder: (context, state, child) {
        final isWeb = MediaQuery.of(context).size.width > 800;
        if (isWeb) {
          return Scaffold(
            body: Row(
              children: [
                const SideMenu(isAdmin: true),
                Expanded(child: child),
              ],
            ),
          );
        }
        return Scaffold(
          body: child,
          bottomNavigationBar: const BottomNav(isAdmin: true),
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.adminDashboard,
          builder: (context, state) {
            final isWeb = MediaQuery.of(context).size.width > 800;
            return isWeb ? const AdminDashboardWeb() : const AdminDashboardMobile();
          },
        ),
        GoRoute(
          path: AppRoutes.adminCourseManagement,
          builder: (context, state) {
            final isWeb = MediaQuery.of(context).size.width > 800;
            return isWeb ? const AdminCourseManagementWeb() : const AdminCourseManagementMobile();
          },
        ),
        GoRoute(
          path: AppRoutes.adminUserManagement,
          builder: (context, state) {
            final isWeb = MediaQuery.of(context).size.width > 800;
            return isWeb ? const AdminUserManagementWeb() : const AdminUserManagementMobile();
          },
        ),
        GoRoute(
          path: AppRoutes.adminQuizManagement,
          builder: (context, state) {
            final isWeb = MediaQuery.of(context).size.width > 800;
            return isWeb ? const AdminQuizManagementWeb() : const AdminQuizManagementMobile();
          },
        ),
        GoRoute(
          path: AppRoutes.adminAnalytics,
          builder: (context, state) {
            final isWeb = MediaQuery.of(context).size.width > 800;
            return isWeb ? const AdminAnalyticsWeb() : const AdminAnalyticsMobile();
          },
        ),
      ],
    ),

    // Main App Routes with Shell
    ShellRoute(
      builder: (context, state, child) {
        final isWeb = MediaQuery.of(context).size.width > 800;
        if (isWeb) {
          return Scaffold(
            body: Row(
              children: [
                const SideMenu(),
                Expanded(child: child),
              ],
            ),
          );
        }
        return Scaffold(
          body: child,
          bottomNavigationBar: const BottomNav(),
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          builder: (context, state) {
            final isWeb = MediaQuery.of(context).size.width > 800;
            return isWeb ? const DashboardWeb() : const DashboardScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.courses,
          builder: (context, state) {
            final isWeb = MediaQuery.of(context).size.width > 800;
            return isWeb ? const CourseListWeb() : const CourseListScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.courseDetail,
          builder: (context, state) {
            final courseId = state.uri.queryParameters['id'] ?? '1';
            final isWeb = MediaQuery.of(context).size.width > 800;
            return isWeb
                ? CourseDetailWeb(courseId: courseId)
                : CourseDetailScreen(courseId: courseId);
          },
        ),
        GoRoute(
          path: AppRoutes.courseContent,
          builder: (context, state) {
            final courseId = state.uri.queryParameters['id'] ?? '1';
            final lessonId = state.uri.queryParameters['lesson'] ?? '1';
            final isWeb = MediaQuery.of(context).size.width > 800;
            return isWeb
                ? CourseContentWeb(courseId: courseId, lessonId: lessonId)
                : CourseContentMobile(courseId: courseId, lessonId: lessonId);
          },
        ),
        GoRoute(
          path: AppRoutes.quiz,
          builder: (context, state) {
            final quizId = state.uri.queryParameters['id'] ?? '1';
            final isWeb = MediaQuery.of(context).size.width > 800;
            return isWeb
                ? QuizWeb(quizId: quizId)
                : QuizScreen(quizId: quizId);
          },
        ),
        GoRoute(
          path: AppRoutes.quizResult,
          builder: (context, state) {
            final quizId = state.uri.queryParameters['id'] ?? '1';
            final isWeb = MediaQuery.of(context).size.width > 800;
            return isWeb
                ? QuizResultWeb(quizId: quizId)
                : QuizResultMobile(quizId: quizId);
          },
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) {
            final isWeb = MediaQuery.of(context).size.width > 800;
            return isWeb ? const ProfileWeb() : const ProfileScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.notifications,
          builder: (context, state) {
            final isWeb = MediaQuery.of(context).size.width > 800;
            return isWeb ? const NotificationsWeb() : const NotificationsScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.certificates,
          builder: (context, state) {
            final isWeb = MediaQuery.of(context).size.width > 800;
            return isWeb ? const CertificatesWeb() : const CertificatesMobile();
          },
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) {
            final isWeb = MediaQuery.of(context).size.width > 800;
            return isWeb ? const SettingsWeb() : const SettingsMobile();
          },
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    final authController = context.read<AuthController>();
    final isAuthenticated = authController.isLoggedIn;
    final isAdmin = authController.user?.role == 'admin';
    final isAuthRoute = state.matchedLocation.startsWith('/login') ||
        state.matchedLocation.startsWith('/signup');
    final isAdminRoute = state.matchedLocation.startsWith('/admin');

    if (!isAuthenticated && !isAuthRoute) {
      return AppRoutes.login;
    }
    if (isAuthenticated && isAuthRoute) {
      return isAdmin ? AppRoutes.adminDashboard : AppRoutes.dashboard;
    }
    if (isAuthenticated && !isAdmin && isAdminRoute) {
      return AppRoutes.dashboard;
    }
    if (isAuthenticated && isAdmin && !isAdminRoute && !isAuthRoute) {
      return AppRoutes.adminDashboard;
    }
    return null;
  },
);