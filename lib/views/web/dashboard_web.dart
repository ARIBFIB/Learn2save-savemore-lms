import 'package:flutter/material.dart';
import 'package:learn2save_lms_flutter_app/models/assessment_model.dart';
import 'package:learn2save_lms_flutter_app/views/shared/course_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/course_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../routes/app_routes.dart';
import '../../utils/formatters.dart';

class DashboardWebScreen extends StatefulWidget {
  const DashboardWebScreen({Key? key}) : super(key: key);

  @override
  State<DashboardWebScreen> createState() => _DashboardWebScreenState();
}

class _DashboardWebScreenState extends State<DashboardWebScreen> {
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
    final dashboardController = Provider.of<DashboardController>(context, listen: false);

    // Set auth token for course controller
    if (authController.authToken != null) {
      courseController.setAuthToken(authController.authToken!);
    }

    // Load dashboard data
    await dashboardController.loadDashboardData();

    // Load user's enrolled courses
    await courseController.loadMyCourses();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize screenutil for responsive design
    ScreenUtil.init(context, designSize: const Size(1440, 900));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250.w,
            color: Colors.white,
            child: Column(
              children: [
                // Logo
                Container(
                  padding: EdgeInsets.all(24.w),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 40.h,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        AppStrings.appName,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Navigation menu
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    children: [
                      _buildNavItem(
                        icon: Icons.dashboard_outlined,
                        title: AppStrings.dashboard,
                        isSelected: true,
                        onTap: () {
                          // Already on dashboard
                        },
                      ),
                      _buildNavItem(
                        icon: Icons.book_outlined,
                        title: AppStrings.courses,
                        isSelected: false,
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.courses);
                        },
                      ),
                      _buildNavItem(
                        icon: Icons.quiz_outlined,
                        title: AppStrings.assessments,
                        isSelected: false,
                        onTap: () {
                          Navigator.of(context).pushNamed('/assessments');
                        },
                      ),
                      _buildNavItem(
                        icon: Icons.verified_outlined,
                        title: AppStrings.certificates,
                        isSelected: false,
                        onTap: () {
                          Navigator.of(context).pushNamed('/certificates');
                        },
                      ),
                      _buildNavItem(
                        icon: Icons.favorite_border_outlined,
                        title: AppStrings.wishlist,
                        isSelected: false,
                        onTap: () {
                          Navigator.of(context).pushNamed('/wishlist');
                        },
                      ),
                    ],
                  ),
                ),

                // User profile
                Container(
                  padding: EdgeInsets.all(16.w),
                  child: Consumer<AuthController>(
                    builder: (context, authController, child) {
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 20.r,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            backgroundImage: authController.user?.profileImageUrl != null
                                ? NetworkImage(authController.user!.profileImageUrl!)
                                : null,
                            child: authController.user?.profileImageUrl == null
                                ? Text(
                              Formatters.formatInitials(
                                '${authController.user?.firstName ?? ''} ${authController.user?.lastName ?? ''}',
                              ),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            )
                                : null,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${authController.user?.firstName ?? ''} ${authController.user?.lastName ?? ''}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  authController.user?.email ?? '',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout),
                            onPressed: () {
                              authController.logout();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Column(
              children: [
                // Top bar
                Container(
                  height: 80.h,
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Consumer<DashboardController>(
                          builder: (context, dashboardController, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Consumer<AuthController>(
                                  builder: (context, authController, child) {
                                    return Text(
                                      '${AppStrings.welcome}, ${authController.user?.firstName ?? AppStrings.user}!',
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  AppStrings.dashboardSubtitle,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      // Search bar
                      Container(
                        width: 300.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search courses...',
                            hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 20.w,
                              color: AppColors.textSecondary,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 24.w),

                      // Notifications
                      Stack(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.notifications_outlined,
                              size: 24.w,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/notifications');
                            },
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Content area
                Expanded(
                  child: Consumer2<DashboardController, CourseController>(
                    builder: (context, dashboardController, courseController, child) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.all(32.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Stats cards
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    title: AppStrings.coursesEnrolled,
                                    value: dashboardController.stats['coursesEnrolled']?.toString() ?? '0',
                                    icon: Icons.book_outlined,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(width: 24.w),
                                Expanded(
                                  child: _buildStatCard(
                                    title: AppStrings.completed,
                                    value: dashboardController.stats['coursesCompleted']?.toString() ?? '0',
                                    icon: Icons.check_circle_outline,
                                    color: AppColors.success,
                                  ),
                                ),
                                SizedBox(width: 24.w),
                                Expanded(
                                  child: _buildStatCard(
                                    title: 'Total Hours',
                                    value: dashboardController.stats['totalHours']?.toString() ?? '0',
                                    icon: Icons.schedule_outlined,
                                    color: AppColors.warning,
                                  ),
                                ),
                                SizedBox(width: 24.w),
                                Expanded(
                                  child: _buildStatCard(
                                    title: 'Certificates',
                                    value: dashboardController.stats['certificatesEarned']?.toString() ?? '0',
                                    icon: Icons.verified_outlined,
                                    color: AppColors.info,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 32.h),

                            // Recent courses and upcoming assessments
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Recent courses
                                Expanded(
                                  flex: 2,
                                  child: _buildRecentCoursesSection(courseController),
                                ),
                                SizedBox(width: 32.w),
                                // Upcoming assessments
                                Expanded(
                                  child: _buildUpcomingAssessmentsSection(dashboardController),
                                ),
                              ],
                            ),

                            SizedBox(height: 32.h),

                            // Recent activities
                            _buildRecentActivitiesSection(dashboardController),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: AppColors.primary.withOpacity(0.1),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(24.w),
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
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCoursesSection(CourseController courseController) {
    return Container(
      padding: EdgeInsets.all(24.w),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.myCourses,
                style: TextStyle(
                  fontSize: 20.sp,
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
          SizedBox(height: 24.h),

          courseController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : courseController.myCourses.isEmpty
              ? _buildEmptyState('No courses enrolled yet')
              : Column(
            children: courseController.myCourses.take(3).map((course) {
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
                  // height: 100.h,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAssessmentsSection(DashboardController dashboardController) {
    return Container(
      padding: EdgeInsets.all(24.w),
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
          Text(
            'Upcoming Assessments',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 24.h),

          dashboardController.upcomingAssessments.isEmpty
              ? _buildEmptyState('No upcoming assessments')
              : Column(
            children: dashboardController.upcomingAssessments.map((assessment) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildAssessmentCard(assessment),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentCard(assessment) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                assessment.type == AssessmentType.quiz
                    ? Icons.quiz_outlined
                    : Icons.assignment_outlined,
                size: 20.w,
                color: AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  assessment.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            assessment.courseName,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.schedule_outlined,
                size: 16.w,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 4.w),
              Text(
                'Due: ${Formatters.formatDate(assessment.dueDate)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '${assessment.durationMinutes} min',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitiesSection(DashboardController dashboardController) {
    return Container(
      padding: EdgeInsets.all(24.w),
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
          Text(
            'Recent Activities',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 24.h),

          dashboardController.recentActivities.isEmpty
              ? _buildEmptyState('No recent activities')
              : Column(
            children: dashboardController.recentActivities.map((activity) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildActivityCard(activity),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    final timestamp = activity['timestamp'] as DateTime;
    final icon = _getActivityIcon(activity['icon']);
    final color = _getActivityColor(activity['color']);

    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20.w,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity['title'],
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                Formatters.formatRelativeTime(timestamp),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      height: 200.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48.w,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActivityIcon(String? iconName) {
    switch (iconName) {
      case 'check_circle':
        return Icons.check_circle_outline;
      case 'play_circle':
        return Icons.play_circle_outline;
      case 'quiz':
        return Icons.quiz_outlined;
      case 'school':
        return Icons.school_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _getActivityColor(String? colorName) {
    switch (colorName) {
      case 'success':
        return AppColors.success;
      case 'primary':
        return AppColors.primary;
      case 'info':
        return AppColors.info;
      case 'warning':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }
}