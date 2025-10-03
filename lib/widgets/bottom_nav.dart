import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import '../routes/app_routes.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              if (currentIndex != 0) {
                Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
              }
              break;
            case 1:
              if (currentIndex != 1) {
                // FIX: Pass a default course ID as an argument
                Navigator.of(context).pushNamed(AppRoutes.courseDetail, arguments: "1");
              }
              break;
            case 2:
              if (currentIndex != 2) {
                Navigator.of(context).pushNamed('/assessments');
              }
              break;
            case 3:
              if (currentIndex != 3) {
                Navigator.of(context).pushNamed('/profile');
              }
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedFontSize: 12.sp,
        unselectedFontSize: 12.sp,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 0 ? Icons.home : Icons.home_outlined,
              size: 24.w,
            ),
            label: AppStrings.dashboard,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 1 ? Icons.book : Icons.book_outlined,
              size: 24.w,
            ),
            label: AppStrings.courses,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 2 ? Icons.quiz : Icons.quiz_outlined,
              size: 24.w,
            ),
            label: AppStrings.assessments,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 3 ? Icons.person : Icons.person_outline,
              size: 24.w,
            ),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}