import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/course_controller.dart';

import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../models/course_model.dart';
import '../shared/buttons.dart';
import '../shared/progress_bar.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({Key? key}) : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  String? _courseId;
  bool _isEnrolled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get course ID from route arguments
    final courseId = ModalRoute.of(context)?.settings.arguments as String?;

    if (courseId != null && courseId != _courseId) {
      _courseId = courseId;
      _loadCourseData();
    }
  }

  Future<void> _loadCourseData() async {
    if (_courseId == null) return;

    final authController = Provider.of<AuthController>(context, listen: false);
    final courseController = Provider.of<CourseController>(context, listen: false);

    // Set auth token for course controller
    if (authController.authToken != null) {
      courseController.setAuthToken(authController.authToken!);
    }

    // Load course details
    await courseController.loadCourseDetails(_courseId!);

    // Check if user is enrolled in this course
    _checkEnrollmentStatus(courseController);

    // Load course progress if enrolled
    if (_isEnrolled) {
      await courseController.loadCourseProgress(_courseId!);
    }
  }

  void _checkEnrollmentStatus(CourseController courseController) {
    if (courseController.myCourses.any((course) => course.id == _courseId)) {
      setState(() {
        _isEnrolled = true;
      });
    }
  }

  Future<void> _enrollInCourse() async {
    if (_courseId == null) return;

    final courseController = Provider.of<CourseController>(context, listen: false);
    final success = await courseController.enrollInCourse(_courseId!);

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
    ScreenUtil.init(context, designSize: const Size(375, 812));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<CourseController>(
        builder: (context, courseController, child) {
          final course = courseController.selectedCourse;

          if (courseController.isLoading || course == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              // App bar with course image
              SliverAppBar(
                expandedHeight: 250.h,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: course.thumbnailUrl != null
                      ? CachedNetworkImage(
                    imageUrl: course.thumbnailUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.primary.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.primary.withOpacity(0.3),
                      child: Icon(
                        Icons.image_not_supported,
                        size: 64.w,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                      : Container(
                    color: AppColors.primary.withOpacity(0.3),
                    child: Icon(
                      Icons.image,
                      size: 64.w,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      // Add to favorites
                    },
                  ),
                ],
              ),

              // Course content
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course title
                      Text(
                        course.title,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Course metadata
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16.w,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            course.instructorName,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Icon(
                            Icons.schedule_outlined,
                            size: 16.w,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${course.duration.inHours}h',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // Course rating and enrolled count
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < course.rating.floor()
                                    ? Icons.star
                                    : index < course.rating
                                    ? Icons.star_half
                                    : Icons.star_border,
                                size: 16.w,
                                color: Colors.amber,
                              );
                            }),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${course.rating.toStringAsFixed(1)} (${course.reviewCount})',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${course.enrolledCount} ${AppStrings.students}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // Course price and enroll button
                      Row(
                        children: [
                          Text(
                            '\$${course.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const Spacer(),
                          courseController.isEnrolling
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                              : _isEnrolled
                              ? OutlinedButton(
                            onPressed: () {
                              // Navigate to course content
                              Navigator.of(context).pushNamed(
                                '/course_content',
                                arguments: course.id,
                              );
                            },
                            child: Text(AppStrings.continueLearning),
                          )
                              : PrimaryButton(
                            text: AppStrings.enrollNow,
                            onPressed: _enrollInCourse,
                          ),
                        ],
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
                        SizedBox(height: 24.h),
                      ],

                      // Tabs for course content
                      DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            TabBar(
                              labelColor: AppColors.primary,
                              indicatorColor: AppColors.primary,
                              tabs: [
                                Tab(text: AppStrings.about),
                                Tab(text: AppStrings.curriculum),
                                Tab(text: AppStrings.reviews),
                              ],
                            ),
                            SizedBox(
                              height: 400.h,
                              child: TabBarView(
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
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAboutTab(Course course) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            AppStrings.description,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            course.description,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),

          SizedBox(height: 24.h),

          // Learning objectives
          Text(
            AppStrings.whatYouWillLearn,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          ...course.learningObjectives.map((objective) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16.w,
                    color: AppColors.success,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      objective,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          SizedBox(height: 24.h),

          // Prerequisites
          if (course.prerequisites.isNotEmpty) ...[
            Text(
              AppStrings.prerequisites,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            ...course.prerequisites.map((prerequisite) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.arrow_right,
                      size: 16.w,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        prerequisite,
                        style: TextStyle(
                          fontSize: 14.sp,
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
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h),
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
    );
  }

  Widget _buildReviewsTab() {
    return Center(
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
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          if (_isEnrolled)
            TextButton(
              onPressed: () {
                // Navigate to add review screen
                Navigator.of(context).pushNamed('/add_review');
              },
              child: Text(
                AppStrings.beFirstToReview,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
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

    if (progress.isEmpty || progress[_courseId] == null) {
      return 0.0;
    }

    final courseProgress = progress[_courseId];
    final completedLessons = courseProgress['completed_lessons'] ?? 0;
    final totalLessons = courseProgress['total_lessons'] ?? 1;

    return completedLessons / totalLessons;
  }
}