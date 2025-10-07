import 'package:flutter/material.dart';
import 'package:learn2save_lms_flutter_app/views/shared/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../constants/dummy_data.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/course_controller.dart';
import 'package:learn2save_lms_flutter_app/views/shared/course_card.dart';
import 'package:learn2save_lms_flutter_app/views/shared/quiz_card.dart';
import 'package:learn2save_lms_flutter_app/views/shared/progress_bar.dart';
import '../../widgets/card_item.dart';
import '../../utils/formatters.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final dashboardController = context.watch<DashboardController>();
    final courseController = context.watch<CourseController>();
    final stats = dashboardController.getDashboardStats();

    return Scaffold(
      appBar: const DashboardAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh data
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Text(
                'Continue Learning',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Enrolled',
                      '${stats['enrolledCourses']}',
                      Icons.book,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Completed',
                      '${stats['completedCourses']}',
                      Icons.check_circle,
                      AppColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Hours',
                      '${stats['learningHours']}',
                      Icons.schedule,
                      AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Achievements',
                      '${stats['achievements']}',
                      Icons.emoji_events,
                      AppColors.secondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Courses
              Text(
                AppStrings.recentCourses,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Course List
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: courseController.enrolledCourses.take(3).length,
                  itemBuilder: (context, index) {
                    final course = courseController.enrolledCourses[index];
                    return SizedBox(
                      width: 280,
                      child: CourseCard(
                        course: course,
                        showProgress: true,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/course-detail',
                            arguments: course.id,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Upcoming Quizzes
              Text(
                AppStrings.upcomingQuizzes,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Quiz List
              ...DummyData.quizzes.map(
                    (quiz) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: QuizCard(
                    quiz: quiz,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/quiz',
                        arguments: quiz.id,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Learning Progress
              Text(
                AppStrings.yourProgress,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Progress Overview
              CardItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Progress',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ProgressBar(
                      progress: 0.65,
                      height: 12,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '65% Complete • 156 hours learned',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Recent Notifications
              Text(
                'Recent Activity',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Notifications List
              ...dashboardController.notifications.take(3).map(
                    (notification) => CardItem(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _getNotificationColor(notification.type).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getNotificationIcon(notification.type),
                          color: _getNotificationColor(notification.type),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              notification.message,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        Formatters.formatRelativeTime(notification.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return CardItem(
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'course':
        return AppColors.primary;
      case 'quiz':
        return AppColors.warning;
      case 'achievement':
        return AppColors.success;
      case 'update':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'course':
        return Icons.book;
      case 'quiz':
        return Icons.quiz;
      case 'achievement':
        return Icons.emoji_events;
      case 'update':
        return Icons.update;
      default:
        return Icons.notifications;
    }
  }
}