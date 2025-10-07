import 'package:flutter/material.dart';
import '../constants/dummy_data.dart';
import '../models/course_model.dart';

class CourseController extends ChangeNotifier {
  List<Course> _courses = [];
  List<Course> _enrolledCourses = [];
  bool _isLoading = false;
  String? _selectedCategory;

  CourseController() {
    _loadCourses();
  }

  // Getters
  List<Course> get courses => _courses;
  List<Course> get enrolledCourses => _enrolledCourses;
  bool get isLoading => _isLoading;
  String? get selectedCategory => _selectedCategory;

  // Load courses
  void _loadCourses() {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      _courses = DummyData.courses;
      _enrolledCourses = _courses.where((course) => course.enrolled).toList();
      _isLoading = false;
      notifyListeners();
    });
  }

  // Filter courses by category
  void filterByCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Get filtered courses
  List<Course> get filteredCourses {
    if (_selectedCategory == null || _selectedCategory == 'All') {
      return _courses;
    }
    return _courses.where((course) => course.category == _selectedCategory).toList();
  }

  // Enroll in a course
  void enrollCourse(String courseId) {
    final courseIndex = _courses.indexWhere((course) => course.id == courseId);
    if (courseIndex != -1) {
      // Update course enrollment status
      _courses[courseIndex] = Course(
        id: _courses[courseIndex].id,
        title: _courses[courseIndex].title,
        description: _courses[courseIndex].description,
        instructor: _courses[courseIndex].instructor,
        instructorAvatar: _courses[courseIndex].instructorAvatar,
        thumbnail: _courses[courseIndex].thumbnail,
        duration: _courses[courseIndex].duration,
        lessons: _courses[courseIndex].lessons,
        students: _courses[courseIndex].students + 1,
        rating: _courses[courseIndex].rating,
        price: _courses[courseIndex].price,
        category: _courses[courseIndex].category,
        level: _courses[courseIndex].level,
        language: _courses[courseIndex].language,
        lastUpdated: _courses[courseIndex].lastUpdated,
        curriculum: _courses[courseIndex].curriculum,
        enrolled: true,
        progress: 0.0,
      );

      _enrolledCourses = _courses.where((course) => course.enrolled).toList();
      notifyListeners();
    }
  }

  // Update course progress
  void updateProgress(String courseId, double progress) {
    final courseIndex = _courses.indexWhere((course) => course.id == courseId);
    if (courseIndex != -1) {
      _courses[courseIndex] = Course(
        id: _courses[courseIndex].id,
        title: _courses[courseIndex].title,
        description: _courses[courseIndex].description,
        instructor: _courses[courseIndex].instructor,
        instructorAvatar: _courses[courseIndex].instructorAvatar,
        thumbnail: _courses[courseIndex].thumbnail,
        duration: _courses[courseIndex].duration,
        lessons: _courses[courseIndex].lessons,
        students: _courses[courseIndex].students,
        rating: _courses[courseIndex].rating,
        price: _courses[courseIndex].price,
        category: _courses[courseIndex].category,
        level: _courses[courseIndex].level,
        language: _courses[courseIndex].language,
        lastUpdated: _courses[courseIndex].lastUpdated,
        curriculum: _courses[courseIndex].curriculum,
        enrolled: _courses[courseIndex].enrolled,
        progress: progress,
      );

      _enrolledCourses = _courses.where((course) => course.enrolled).toList();
      notifyListeners();
    }
  }

  // Search courses
  List<Course> searchCourses(String query) {
    if (query.isEmpty) return _courses;

    return _courses.where((course) {
      return course.title.toLowerCase().contains(query.toLowerCase()) ||
          course.description.toLowerCase().contains(query.toLowerCase()) ||
          course.instructor.toLowerCase().contains(query.toLowerCase()) ||
          course.category.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}