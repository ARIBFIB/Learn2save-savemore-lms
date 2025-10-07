import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../constants/dummy_data.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/course_controller.dart';
import '../../widgets/card_item.dart';
import '../../utils/formatters.dart';
import '../shared/buttons.dart';

class AdminDashboardWeb extends StatelessWidget {
  const AdminDashboardWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final dashboardController = context.watch<DashboardController>();
    final courseController = context.watch<CourseController>();
    final analyticsData = DummyData.analyticsData;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Dashboard',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome back, ${authController.user?.name ?? 'Admin'}!',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Date Range Selector
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.textLight.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.date_range, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text(
                            'Last 30 days',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Export Button
                    PrimaryButton(
                      text: 'Export Report',
                      onPressed: () {
                        // Export functionality
                      },
                      // icon: Icons.download,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Users',
                    '${analyticsData['totalUsers']}',
                    Icons.people,
                    AppColors.primary,
                    '+${analyticsData['activeUsers']} active',
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildStatCard(
                    'Total Courses',
                    '${analyticsData['totalCourses']}',
                    Icons.book,
                    AppColors.secondary,
                    '${courseController.courses.length} published',
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildStatCard(
                    'Total Enrollments',
                    '${analyticsData['totalEnrollments']}',
                    Icons.school,
                    AppColors.success,
                    '+12% from last month',
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildStatCard(
                    'Total Revenue',
                    '\$${analyticsData['totalRevenue']}',
                    Icons.attach_money,
                    AppColors.warning,
                    '+8% from last month',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Charts and Tables
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Revenue Chart
                  Expanded(
                    flex: 2,
                    child: CardItem(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Monthly Revenue',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Placeholder for chart
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.bar_chart,
                                      size: 64,
                                      color: AppColors.textLight,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Revenue Chart',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Chart would be displayed here',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 24),

                  // Recent Activities
                  Expanded(
                    child: CardItem(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recent Activities',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView(
                              children: [
                                _buildActivityItem(
                                  'New user registration',
                                  'Abdul Wahab joined the platform',
                                  Icons.person_add,
                                  AppColors.success,
                                  '2 hours ago',
                                ),
                                _buildActivityItem(
                                  'New course published',
                                  'Advanced JavaScript is now live',
                                  Icons.book,
                                  AppColors.primary,
                                  '5 hours ago',
                                ),
                                _buildActivityItem(
                                  'Quiz completed',
                                  'Jane Smith completed Flutter Basics',
                                  Icons.quiz,
                                  AppColors.warning,
                                  '1 day ago',
                                ),
                                _buildActivityItem(
                                  'Payment received',
                                  '\$89.99 from Robert Johnson',
                                  Icons.payment,
                                  AppColors.success,
                                  '2 days ago',
                                ),
                                _buildActivityItem(
                                  'Course updated',
                                  'React course content updated',
                                  Icons.update,
                                  AppColors.info,
                                  '3 days ago',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Top Courses and Users
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Courses
                Expanded(
                  child: CardItem(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Top Courses',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...DummyData.analyticsData['courseEnrollments'].entries.map(
                              (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${entry.value} enrollments',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
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

                const SizedBox(width: 24),

                // Course Completions
                Expanded(
                  child: CardItem(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Course Completions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '${DummyData.analyticsData['courseCompletions']['completed']}',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.success,
                                    ),
                                  ),
                                  const Text(
                                    'Completed',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 60,
                              color: AppColors.textLight.withOpacity(0.3),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '${DummyData.analyticsData['courseCompletions']['inProgress']}',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.warning,
                                    ),
                                  ),
                                  const Text(
                                    'In Progress',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle) {
    return CardItem(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String description, IconData icon, Color color, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminDashboardMobile extends StatelessWidget {
  const AdminDashboardMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final analyticsData = DummyData.analyticsData;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Admin Dashboard',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome back, ${authController.user?.name ?? 'Admin'}!',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // Stats Cards
            _buildStatCard('Total Users', '${analyticsData['totalUsers']}', Icons.people, AppColors.primary),
            const SizedBox(height: 16),
            _buildStatCard('Total Courses', '${analyticsData['totalCourses']}', Icons.book, AppColors.secondary),
            const SizedBox(height: 16),
            _buildStatCard('Total Enrollments', '${analyticsData['totalEnrollments']}', Icons.school, AppColors.success),
            const SizedBox(height: 16),
            _buildStatCard('Total Revenue', '\$${analyticsData['totalRevenue']}', Icons.attach_money, AppColors.warning),

            const SizedBox(height: 24),

            // Recent Activities
            const Text(
              'Recent Activities',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            CardItem(
              child: Column(
                children: [
                  _buildActivityItem(
                    'New user registration',
                    'Abdul Wahab joined the platform',
                    Icons.person_add,
                    AppColors.success,
                    '2 hours ago',
                  ),
                  const Divider(),
                  _buildActivityItem(
                    'New course published',
                    'Advanced JavaScript is now live',
                    Icons.book,
                    AppColors.primary,
                    '5 hours ago',
                  ),
                  const Divider(),
                  _buildActivityItem(
                    'Quiz completed',
                    'Jane Smith completed Flutter Basics',
                    Icons.quiz,
                    AppColors.warning,
                    '1 day ago',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CardItem(
                    onTap: () {
                      // Navigate to course management
                    },
                    child: Column(
                      children: [
                        Icon(Icons.book, size: 32, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Text(
                          'Manage Courses',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CardItem(
                    onTap: () {
                      // Navigate to user management
                    },
                    child: Column(
                      children: [
                        Icon(Icons.people, size: 32, color: AppColors.secondary),
                        const SizedBox(height: 8),
                        Text(
                          'Manage Users',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return CardItem(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
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

  Widget _buildActivityItem(String title, String description, IconData icon, Color color, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}