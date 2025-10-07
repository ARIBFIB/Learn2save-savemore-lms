import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/colors.dart';
import '../../models/user_model.dart';

class ProfileCard extends StatelessWidget {
  final User user;
  final bool showStats;

  const ProfileCard({
    super.key,
    required this.user,
    this.showStats = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: CachedNetworkImageProvider(user.avatar),
            ),

            const SizedBox(height: 16),

            // User Name
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 4),

            // User Email
            Text(
              user.email,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 8),

            // User Bio
            Text(
              user.bio,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),

            if (showStats) ...[
              const SizedBox(height: 20),

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat(
                    'Courses',
                    '${user.enrolledCourses.length}',
                  ),
                  _buildStat(
                    'Completed',
                    '${user.completedCourses.length}',
                  ),
                  _buildStat(
                    'Hours',
                    '${user.totalLearningHours}',
                  ),
                ],
              ),
            ],

            const SizedBox(height: 20),

            // Join Date
            Text(
              'Member since ${_formatDate(user.joinDate)}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
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
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.year}';
  }
}