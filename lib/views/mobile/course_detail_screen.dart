import 'package:flutter/material.dart';
import 'package:learn2save_lms_flutter_app/views/shared/app_bar.dart';
import 'package:learn2save_lms_flutter_app/views/shared/buttons.dart';
import 'package:learn2save_lms_flutter_app/views/shared/progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../controllers/course_controller.dart';
import '../../widgets/card_item.dart';
import '../../utils/formatters.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailScreen({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    final courseController = context.watch<CourseController>();
    final course = courseController.courses.firstWhere(
          (c) => c.id == courseId,
      orElse: () => courseController.courses.first,
    );

    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.courses,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Header Image
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: course.thumbnail,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(course.instructorAvatar),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            course.instructor,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        Icons.schedule,
                        course.duration,
                      ),
                      _buildStatItem(
                        Icons.book,
                        '${course.lessons} Lessons',
                      ),
                      _buildStatItem(
                        Icons.people,
                        '${course.students}',
                      ),
                      _buildStatItem(
                        Icons.star,
                        '${course.rating}',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Progress (if enrolled)
                  if (course.enrolled) ...[
                    Text(
                      'Your Progress',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ProgressBar(
                      progress: course.progress,
                      height: 12,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(course.progress * 100).toInt()}% Complete',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Description
                  Text(
                    AppStrings.description,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    course.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Curriculum
                  Text(
                    AppStrings.curriculum,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...course.curriculum.asMap().entries.map(
                        (entry) => CardItem(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${entry.key + 1}',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.lock_open,
                            size: 16,
                            color: course.enrolled
                                ? AppColors.success
                                : AppColors.textLight,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Enroll/Start Button
                  if (!course.enrolled)
                    PrimaryButton(
                      text: AppStrings.enrollNow,
                      onPressed: () {
                        courseController.enrollCourse(course.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Successfully enrolled in ${course.title}'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                    )
                  else
                    PrimaryButton(
                      text: AppStrings.startLearning,
                      onPressed: () {
                        // Navigate to first lesson
                      },
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}