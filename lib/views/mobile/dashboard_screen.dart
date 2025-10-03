import 'package:flutter/material.dart';
import 'package:learn2save_lms_flutter_app/views/shared/course_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/course_controller.dart';
import '../../widgets/bottom_nav.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../routes/app_routes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }

  Future<void> _loadDashboardData() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final courseController = Provider.of<CourseController>(context, listen: false);

    // Set auth token for course controller
    if (authController.authToken != null) {
      courseController.setAuthToken(authController.authToken!);
    }

    // Load user's enrolled courses
    await courseController.loadMyCourses();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize screenutil for responsive design
    ScreenUtil.init(context, designSize: const Size(375, 812));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.dashboard,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigate to notifications screen
              Navigator.of(context).pushNamed(AppRoutes.notifications);
            },
          ),
        ],
      ),
      body: Consumer2<AuthController, CourseController>(
        builder: (context, authController, courseController, child) {
          return RefreshIndicator(
            onRefresh: _loadDashboardData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome message
                  Text(
                    '${AppStrings.welcome}, ${authController.user?.firstName ?? AppStrings.user}!',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    AppStrings.dashboardSubtitle,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Stats cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: AppStrings.coursesEnrolled,
                          value: courseController.myCourses.length.toString(),
                          icon: Icons.book_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _buildStatCard(
                          title: AppStrings.completed,
                          value: _calculateCompletedCourses(courseController).toString(),
                          icon: Icons.check_circle_outline,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Section header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.myCourses,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.courses);
                        },
                        child: Text(
                          AppStrings.viewAll,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Course list
                  courseController.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : courseController.myCourses.isEmpty
                      ? _buildEmptyState()
                      : _buildCourseList(courseController),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 24.w,
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 64.w,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              AppStrings.noCoursesEnrolled,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.courses);
              },
              child: Text(
                AppStrings.browseCourses,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseList(CourseController courseController) {
    // Show only first 3 courses on dashboard
    final courses = courseController.myCourses.take(3).toList();

    return Column(
      children: courses.map((course) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: CourseCard(
            course: course,
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.courseDetail,
                arguments: course.id,
              );
            },
            showProgress: true,
            progress: _calculateCourseProgress(courseController, course.id),
          ),
        );
      }).toList(),
    );
  }

  int _calculateCompletedCourses(CourseController courseController) {
    // This is a simplified calculation
    // In a real app, you would check the actual completion status
    return courseController.myCourses.where((course) {
      return _calculateCourseProgress(courseController, course.id) >= 1.0;
    }).length;
  }

  double _calculateCourseProgress(CourseController courseController, String courseId) {
    // Get progress data for this course
    final progress = courseController.courseProgress;

    if (progress.isEmpty || progress[courseId] == null) {
      return 0.0;
    }

    final courseProgress = progress[courseId];
    final completedLessons = courseProgress['completed_lessons'] ?? 0;
    final totalLessons = courseProgress['total_lessons'] ?? 1;

    return completedLessons / totalLessons;
  }
}