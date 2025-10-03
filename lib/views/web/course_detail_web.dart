import 'package:flutter/material.dart';
import 'package:learn2save_lms_flutter_app/views/shared/buttons.dart';
import 'package:learn2save_lms_flutter_app/views/shared/progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/course_controller.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../models/course_model.dart';
import '../../utils/formatters.dart';

class CourseDetailWebScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailWebScreen({
    Key? key,
    required this.courseId,
  }) : super(key: key);

  @override
  State<CourseDetailWebScreen> createState() => _CourseDetailWebScreenState();
}

class _CourseDetailWebScreenState extends State<CourseDetailWebScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isEnrolled = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCourseData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCourseData() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final courseController = Provider.of<CourseController>(context, listen: false);

    // Set auth token for course controller
    if (authController.authToken != null) {
      courseController.setAuthToken(authController.authToken!);
    }

    // Load course details
    await courseController.loadCourseDetails(widget.courseId);

    // Check if user is enrolled in this course
    _checkEnrollmentStatus(courseController);

    // Load course progress if enrolled
    if (_isEnrolled) {
      await courseController.loadCourseProgress(widget.courseId);
    }
  }

  void _checkEnrollmentStatus(CourseController courseController) {
    if (courseController.myCourses.any((course) => course.id == widget.courseId)) {
      setState(() {
        _isEnrolled = true;
      });
    }
  }

  Future<void> _enrollInCourse() async {
    final courseController = Provider.of<CourseController>(context, listen: false);
    final success = await courseController.enrollInCourse(widget.courseId);

    if (success) {
      setState(() {
        _isEnrolled = true;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.enrollmentSuccess),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize screenutil for responsive design
    ScreenUtil.init(context, designSize: const Size(1440, 900));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<CourseController>(
        builder: (context, courseController, child) {
          final course = courseController.selectedCourse;

          if (courseController.isLoading || course == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course header with image
                _buildCourseHeader(course),

                // Course content
                Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main content
                      Expanded(
                        flex: 2,
                        child: _buildMainContent(course, courseController),
                      ),
                      SizedBox(width: 32.w),
                      // Sidebar
                      Expanded(
                        child: _buildSidebar(course, courseController),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseHeader(Course course) {
    return Container(
      height: 300.h,
      decoration: BoxDecoration(
        color: AppColors.primary,
        image: course.thumbnailUrl != null
            ? DecorationImage(
          image: NetworkImage(course.thumbnailUrl!),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        )
            : null,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              course.title,
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 20.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  course.instructorName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 24.w),
                Icon(
                  Icons.schedule_outlined,
                  color: Colors.white,
                  size: 20.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  '${course.duration.inHours} hours',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 24.w),
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  '${course.rating.toStringAsFixed(1)} (${course.reviewCount} reviews)',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(Course course, CourseController courseController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tabs
        Container(
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
            children: [
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                indicatorColor: AppColors.primary,
                tabs: [
                  Tab(text: AppStrings.about),
                  Tab(text: AppStrings.curriculum),
                  Tab(text: AppStrings.reviews),
                ],
              ),
              SizedBox(
                height: 500.h,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // About tab
                    _buildAboutTab(course),

                    // Curriculum tab
                    _buildCurriculumTab(course),

                    // Reviews tab
                    _buildReviewsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar(Course course, CourseController courseController) {
    return Column(
      children: [
        // Course info card
        Container(
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
              // Price
              Text(
                '\$${course.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 24.h),

              // Enroll button
              courseController.isEnrolling
                  ? const Center(child: CircularProgressIndicator())
                  : _isEnrolled
                  ? OutlinedButton(
                onPressed: () {
                  // Navigate to course content
                  Navigator.of(context).pushNamed(
                    '/course_content',
                    arguments: course.id,
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48.h),
                ),
                child: Text(
                  AppStrings.continueLearning,
                  style: TextStyle(fontSize: 16.sp),
                ),
              )
                  : PrimaryButton(
                text: AppStrings.enrollNow,
                onPressed: _enrollInCourse,
                height: 48.h,
                fontSize: 16.sp,
              ),

              SizedBox(height: 24.h),

              // Progress bar (if enrolled)
              if (_isEnrolled) ...[
                Text(
                  AppStrings.yourProgress,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                ProgressBar(
                  progress: _calculateCourseProgress(courseController),
                  height: 8.h,
                ),
                SizedBox(height: 16.h),
              ],

              // Course features
              _buildFeatureItem(Icons.schedule_outlined, 'Duration', '${course.duration.inHours} hours'),
              SizedBox(height: 12.h),
              _buildFeatureItem(Icons.quiz_outlined, 'Assessments', '${course.modules.fold<int>(0, (sum, module) => sum + module.lessons.where((lesson) => lesson.type == LessonType.quiz).length)}'),
              SizedBox(height: 12.h),
              _buildFeatureItem(Icons.verified_outlined, 'Certificate', 'Yes'),
              SizedBox(height: 12.h),
              _buildFeatureItem(Icons.people_outline, 'Students', '${course.enrolledCount} enrolled'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.w,
          color: AppColors.textSecondary,
        ),
        SizedBox(width: 12.w),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutTab(Course course) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            AppStrings.description,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            course.description,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),

          SizedBox(height: 32.h),

          // Learning objectives
          Text(
            AppStrings.whatYouWillLearn,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          ...course.learningObjectives.map((objective) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 20.w,
                    color: AppColors.success,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      objective,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          SizedBox(height: 32.h),

          // Prerequisites
          if (course.prerequisites.isNotEmpty) ...[
            Text(
              AppStrings.prerequisites,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            ...course.prerequisites.map((prerequisite) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.arrow_right,
                      size: 20.w,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        prerequisite,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildCurriculumTab(Course course) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: course.modules.length,
        itemBuilder: (context, index) {
          final module = course.modules[index];
          return ExpansionTile(
            title: Text(
              'Module ${index + 1}: ${module.title}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              '${module.lessons.length} ${AppStrings.lessons}',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
            children: module.lessons.map((lesson) {
              return ListTile(
                leading: Icon(
                  _getLessonIcon(lesson.type),
                  color: AppColors.primary,
                ),
                title: Text(
                  lesson.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                trailing: Text(
                  '${lesson.durationMinutes} min',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: () {
                  if (_isEnrolled && !module.isLocked) {
                    // Navigate to lesson content
                    Navigator.of(context).pushNamed(
                      '/lesson_content',
                      arguments: {
                        'courseId': course.id,
                        'moduleId': module.id,
                        'lessonId': lesson.id,
                      },
                    );
                  } else if (!_isEnrolled) {
                    // Show enrollment prompt
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppStrings.enrollToAccess),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  }
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 64.w,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              AppStrings.noReviewsYet,
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 16.h),
            if (_isEnrolled)
              ElevatedButton(
                onPressed: () {
                  // Navigate to add review screen
                  Navigator.of(context).pushNamed('/add_review');
                },
                child: Text(AppStrings.beFirstToReview),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getLessonIcon(LessonType type) {
    switch (type) {
      case LessonType.video:
        return Icons.play_circle_outline;
      case LessonType.text:
        return Icons.article_outlined;
      case LessonType.quiz:
        return Icons.quiz_outlined;
      case LessonType.assignment:
        return Icons.assignment_outlined;
    }
  }

  double _calculateCourseProgress(CourseController courseController) {
    // Get progress data for this course
    final progress = courseController.courseProgress;

    if (progress.isEmpty || progress[widget.courseId] == null) {
      return 0.0;
    }

    final courseProgress = progress[widget.courseId];
    final completedLessons = courseProgress['completed_lessons'] ?? 0;
    final totalLessons = courseProgress['total_lessons'] ?? 1;

    return completedLessons / totalLessons;
  }
}