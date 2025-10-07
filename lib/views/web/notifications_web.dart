import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../controllers/dashboard_controller.dart';
import 'package:learn2save_lms_flutter_app/views/shared/buttons.dart';
import '../../utils/formatters.dart';

class NotificationsWeb extends StatelessWidget {
  const NotificationsWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = context.watch<DashboardController>();

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
                const Text(
                  AppStrings.notifications,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (dashboardController.notifications.isNotEmpty)
                  PrimaryButton(
                    text: AppStrings.markAllAsRead,
                    onPressed: dashboardController.markAllAsRead,
                    height: 40,
                  ),
              ],
            ),

            const SizedBox(height: 32),

            // Notifications List
            Expanded(
              child: dashboardController.isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : dashboardController.notifications.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off,
                      size: 64,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.noNotifications,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: dashboardController.notifications.length,
                itemBuilder: (context, index) {
                  final notification = dashboardController.notifications[index];
                  return _buildNotificationItem(
                    context,
                    notification,
                    dashboardController,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
      BuildContext context,
      notification,
      DashboardController controller,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: notification.isRead
            ? AppColors.surface
            : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isRead
              ? AppColors.textLight.withOpacity(0.2)
              : AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getNotificationColor(notification.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getNotificationIcon(notification.type),
              color: _getNotificationColor(notification.type),
              size: 28,
            ),
          ),

          const SizedBox(width: 20),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: notification.isRead
                        ? FontWeight.normal
                        : FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  Formatters.formatRelativeTime(notification.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Row(
            children: [
              if (!notification.isRead)
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  if (!notification.isRead) {
                    controller.markAsRead(notification.id);
                  }
                },
                icon: Icon(
                  notification.isRead ? Icons.mark_email_read : Icons.mark_email_unread,
                  color: AppColors.textLight,
                ),
              ),
            ],
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