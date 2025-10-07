import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../routes/app_routes.dart';

class BottomNav extends StatelessWidget {
  final bool isAdmin;

  const BottomNav({super.key, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _getCurrentIndex(location),
      onTap: (index) {
        _navigateTo(context, index);
      },
      items: isAdmin
          ? const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_outlined),
          activeIcon: Icon(Icons.book),
          label: 'Courses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outlined),
          activeIcon: Icon(Icons.people),
          label: 'Users',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.quiz_outlined),
          activeIcon: Icon(Icons.quiz),
          label: 'Quizzes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          activeIcon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
      ]
          : const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: AppStrings.dashboard,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_outlined),
          activeIcon: Icon(Icons.book),
          label: AppStrings.courses,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.quiz_outlined),
          activeIcon: Icon(Icons.quiz),
          label: AppStrings.quiz,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          activeIcon: Icon(Icons.notifications),
          label: AppStrings.notifications,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          activeIcon: Icon(Icons.person),
          label: AppStrings.profile,
        ),
      ],
      selectedItemColor: isAdmin ? AppColors.secondary : AppColors.primary,
      unselectedItemColor: AppColors.textLight,
      backgroundColor: AppColors.surface,
      elevation: 8,
    );
  }

  int _getCurrentIndex(String location) {
    if (isAdmin) {
      if (location.startsWith('/admin/dashboard')) return 0;
      if (location.startsWith('/admin/courses')) return 1;
      if (location.startsWith('/admin/users')) return 2;
      if (location.startsWith('/admin/quizzes')) return 3;
      if (location.startsWith('/admin/analytics')) return 4;
      return 0;
    } else {
      if (location.startsWith(AppRoutes.dashboard)) return 0;
      if (location.startsWith(AppRoutes.courses)) return 1;
      if (location.startsWith(AppRoutes.quiz)) return 2;
      if (location.startsWith(AppRoutes.notifications)) return 3;
      if (location.startsWith(AppRoutes.profile)) return 4;
      return 0;
    }
  }

  void _navigateTo(BuildContext context, int index) {
    if (isAdmin) {
      switch (index) {
        case 0:
          context.go(AppRoutes.adminDashboard);
          break;
        case 1:
          context.go(AppRoutes.adminCourseManagement);
          break;
        case 2:
          context.go(AppRoutes.adminUserManagement);
          break;
        case 3:
          context.go(AppRoutes.adminQuizManagement);
          break;
        case 4:
          context.go(AppRoutes.adminAnalytics);
          break;
      }
    } else {
      switch (index) {
        case 0:
          context.go(AppRoutes.dashboard);
          break;
        case 1:
          context.go(AppRoutes.courses);
          break;
        case 2:
          context.go('${AppRoutes.quiz}?id=1');
          break;
        case 3:
          context.go(AppRoutes.notifications);
          break;
        case 4:
          context.go(AppRoutes.profile);
          break;
      }
    }
  }
}