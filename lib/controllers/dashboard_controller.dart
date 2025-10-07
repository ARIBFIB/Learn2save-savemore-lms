import 'package:flutter/material.dart';
import '../constants/dummy_data.dart';
import '../models/assessment_model.dart';

class DashboardController extends ChangeNotifier {
  List<NotificationItem> _notifications = [];
  bool _isLoading = false;

  DashboardController() {
    _loadNotifications();
  }

  // Getters
  List<NotificationItem> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  // Load notifications
  void _loadNotifications() {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      _notifications = DummyData.notifications;
      _isLoading = false;
      notifyListeners();
    });
  }

  // Mark notification as read
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = NotificationItem(
        id: _notifications[index].id,
        title: _notifications[index].title,
        message: _notifications[index].message,
        timestamp: _notifications[index].timestamp,
        isRead: true,
        type: _notifications[index].type,
      );
      notifyListeners();
    }
  }

  // Mark all notifications as read
  void markAllAsRead() {
    _notifications = _notifications.map((notification) {
      return NotificationItem(
        id: notification.id,
        title: notification.title,
        message: notification.message,
        timestamp: notification.timestamp,
        isRead: true,
        type: notification.type,
      );
    }).toList();
    notifyListeners();
  }

  // Get stats for dashboard
  Map<String, dynamic> getDashboardStats() {
    final enrolledCourses = DummyData.courses.where((c) => c.enrolled).length;
    final completedCourses = DummyData.courses.where((c) => c.progress >= 1.0).length;
    final totalQuizzes = DummyData.quizzes.length;
    final achievements = DummyData.currentUser.achievements.length;

    return {
      'enrolledCourses': enrolledCourses,
      'completedCourses': completedCourses,
      'totalQuizzes': totalQuizzes,
      'achievements': achievements,
      'learningHours': DummyData.currentUser.totalLearningHours,
    };
  }
}