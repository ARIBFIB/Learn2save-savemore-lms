import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../controllers/course_controller.dart';
import 'package:learn2save_lms_flutter_app/views/shared/buttons.dart';
import 'package:learn2save_lms_flutter_app/views/shared/progress_bar.dart';
import '../../widgets/card_item.dart';

class CourseDetailWeb extends StatelessWidget {
  final String courseId;

  const CourseDetailWeb({
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
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Image
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: course.thumbnail,
                      height: 400,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                // Course Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(course.instructorAvatar),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.instructor,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Instructor',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Stats
                      Row(
                        children: [
                          _buildStatItem(Icons.schedule, course.duration),
                          const SizedBox(width: 24),
                          _buildStatItem(Icons.book, '${course.lessons} Lessons'),
                          const SizedBox(width: 24),
                          _buildStatItem(Icons.people, '${course.students} Students'),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Rating
                      Row(
                        children: [
                          Row(
                            children: List.generate(
                              5,
                                  (index) => Icon(
                                index < course.rating.floor()
                                    ? Icons.star
                                    : index < course.rating
                                    ? Icons.star_half
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${course.rating} (${course.students} reviews)',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
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
                            fontWeight: FontWeight.w600,
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

                      // Price and Enroll Button
                      Row(
                        children: [
                          if (!course.enrolled) ...[
                            Text(
                              '\$${course.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 24),
                          ],
                          Expanded(
                            child: PrimaryButton(
                              text: course.enrolled
                                  ? AppStrings.startLearning
                                  : AppStrings.enrollNow,
                              onPressed: () {
                                if (!course.enrolled) {
                                  courseController.enrollCourse(course.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Successfully enrolled in ${course.title}'),
                                      backgroundColor: AppColors.success,
                                    ),
                                  );
                                }
                              },
                              height: 56,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 48),

            // Course Content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description and Curriculum
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      const Text(
                        AppStrings.description,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        course.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Curriculum
                      const Text(
                        AppStrings.curriculum,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      ...course.curriculum.asMap().entries.map(
                            (entry) => CardItem(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
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
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.lock_open,
                                size: 20,
                                color: course.enrolled
                                    ? AppColors.success
                                    : AppColors.textLight,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 32),

                // Sidebar
                Expanded(
                  child: Column(
                    children: [
                      // Course Details Card
                      CardItem(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Course Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow('Level', course.level),
                            _buildDetailRow('Language', course.language),
                            _buildDetailRow('Category', course.category),
                            _buildDetailRow(
                              'Last Updated',
                              '${course.lastUpdated.day}/${course.lastUpdated.month}/${course.lastUpdated.year}',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Requirements Card
                      CardItem(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Requirements',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...['Basic computer skills', 'Internet connection', 'Dedication to learn']
                                .map((requirement) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      requirement,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Text(':'),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}