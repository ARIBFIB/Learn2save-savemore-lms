import 'package:flutter/foundation.dart';
import '../models/course_model.dart';
import '../models/assessment_model.dart';
import '../controllers/auth_controller.dart';
import '../controllers/course_controller.dart';

class DashboardController extends ChangeNotifier {
  final AuthController? _authController;
  final CourseController? _courseController;

  DashboardController([this._authController, this._courseController]);

  // Private state variables
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic> _stats = {};
  List<Course> _recentCourses = [];
  List<Assessment> _upcomingAssessments = [];
  List<Map<String, dynamic>> _recentActivities = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic> get stats => _stats;
  List<Course> get recentCourses => _recentCourses;
  List<Assessment> get upcomingAssessments => _upcomingAssessments;
  List<Map<String, dynamic>> get recentActivities => _recentActivities;

  // Load dashboard data
  Future<void> loadDashboardData() async {
    _setLoading(true);
    _clearError();

    try {
      // In a real app, you would fetch this data from your API
      // For now, we'll simulate it with mock data

      // Load stats
      await _loadStats();

      // Load recent courses
      await _loadRecentCourses();

      // Load upcoming assessments
      await _loadUpcomingAssessments();

      // Load recent activities
      await _loadRecentActivities();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load dashboard data: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Load user statistics
  Future<void> _loadStats() async {
    // Mock data - in a real app, fetch from API
    _stats = {
      'coursesEnrolled': 5,
      'coursesCompleted': 2,
      'totalHours': 24,
      'certificatesEarned': 2,
      'averageScore': 85.5,
      'streak': 7, // days in a row
    };
  }

  // Load recent courses
  Future<void> _loadRecentCourses() async {
    if (_courseController != null) {
      // Use courses from course controller if available
      _recentCourses = _courseController!.myCourses.take(3).toList();
    } else {
      // Mock data - in a real app, fetch from API
      _recentCourses = [
        Course(
          id: '1',
          title: 'Flutter Development',
          description: 'Learn Flutter from scratch',
          instructorId: 'inst1',
          instructorName: 'John Doe',
          thumbnailUrl: 'https://example.com/flutter.jpg',
          categories: ['Development', 'Mobile'],
          price: 49.99,
          duration: const Duration(hours: 20),
          enrolledCount: 150,
          rating: 4.8,
          reviewCount: 25,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now().subtract(const Duration(days: 5)),
          status: CourseStatus.published,
        ),
        Course(
          id: '2',
          title: 'Web Development',
          description: 'Learn modern web development',
          instructorId: 'inst2',
          instructorName: 'Jane Smith',
          thumbnailUrl: 'https://example.com/web.jpg',
          categories: ['Development', 'Web'],
          price: 59.99,
          duration: const Duration(hours: 30),
          enrolledCount: 200,
          rating: 4.7,
          reviewCount: 30,
          createdAt: DateTime.now().subtract(const Duration(days: 45)),
          updatedAt: DateTime.now().subtract(const Duration(days: 10)),
          status: CourseStatus.published,
        ),
      ];
    }
  }

  // Load upcoming assessments
  Future<void> _loadUpcomingAssessments() async {
    // Mock data - in a real app, fetch from API
    _upcomingAssessments = [
      Assessment(
        id: '1',
        title: 'Flutter Basics Quiz',
        description: 'Test your knowledge of Flutter basics',
        courseId: '1',
        courseName: 'Flutter Development',
        type: AssessmentType.quiz,
        totalQuestions: 10,
        durationMinutes: 30,
        dueDate: DateTime.now().add(const Duration(days: 3)),
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        status: AssessmentStatus.pending,
      ),
      Assessment(
        id: '2',
        title: 'Web Development Assignment',
        description: 'Build a responsive website',
        courseId: '2',
        courseName: 'Web Development',
        type: AssessmentType.assignment,
        totalQuestions: 1,
        durationMinutes: 120,
        dueDate: DateTime.now().add(const Duration(days: 7)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        status: AssessmentStatus.pending,
      ),
    ];
  }

  // Load recent activities
  Future<void> _loadRecentActivities() async {
    // Mock data - in a real app, fetch from API
    _recentActivities = [
      {
        'id': '1',
        'type': 'course_completed',
        'title': 'Completed course: Introduction to Programming',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'icon': 'check_circle',
        'color': 'success',
      },
      {
        'id': '2',
        'type': 'lesson_completed',
        'title': 'Completed lesson: Flutter Widgets',
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
        'icon': 'play_circle',
        'color': 'primary',
      },
      {
        'id': '3',
        'type': 'assessment_submitted',
        'title': 'Submitted quiz: JavaScript Basics',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'icon': 'quiz',
        'color': 'info',
      },
      {
        'id': '4',
        'type': 'course_enrolled',
        'title': 'Enrolled in course: React Native Development',
        'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        'icon': 'school',
        'color': 'warning',
      },
    ];
  }

  // Refresh dashboard data
  Future<void> refresh() async {
    await loadDashboardData();
  }

  // Helper methods to update state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}