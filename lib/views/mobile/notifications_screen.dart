import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../controllers/dashboard_controller.dart';
import 'package:learn2save_lms_flutter_app/views/shared/app_bar.dart';
import '../../utils/formatters.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = context.watch<DashboardController>();

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.notifications,
        actions: [
          if (dashboardController.notifications.isNotEmpty)
            TextButton(
              onPressed: dashboardController.markAllAsRead,
              child: Text(
                AppStrings.markAllAsRead,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
      body: dashboardController.isLoading
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
        padding: const EdgeInsets.all(16),
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
    );
  }

  Widget _buildNotificationItem(
      BuildContext context,
      notification,
      DashboardController controller,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getNotificationColor(notification.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: _getNotificationColor(notification.type),
            size: 24,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
        trailing: !notification.isRead
            ? Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        )
            : null,
        onTap: () {
          if (!notification.isRead) {
            controller.markAsRead(notification.id);
          }
          // Handle notification tap
        },
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