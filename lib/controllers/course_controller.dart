import 'package:flutter/foundation.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';
import '../controllers/auth_controller.dart';

class CourseController extends ChangeNotifier {
  List<Course> _allCourses = [];
  List<Course> _myCourses = [];
  Course? _selectedCourse;
  bool _isLoading = false;
  bool _isEnrolling = false;
  String? _errorMessage;
  Map<String, dynamic> _courseProgress = {};

  // Getters
  List<Course> get courses => _allCourses;
  List<Course> get myCourses => _myCourses;
  Course? get selectedCourse => _selectedCourse;
  bool get isLoading => _isLoading;
  bool get isEnrolling => _isEnrolling;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic> get courseProgress => _courseProgress;

  CourseController(CourseService courseService); // Constructor for dummy data

  // final CourseService _courseService;
  //
  // CourseController(this._courseService);
  //
  // // Private state variables
  List<Course> _courses = [];

  // List<Course> _myCourses = [];
  // Course? _selectedCourse;
  // bool _isLoading = false;
  // bool _isEnrolling = false;
  // String? _errorMessage;
  // Map<String, dynamic> _courseProgress = {};
  //
  // // Getters
  // List<Course> get courses => _courses;
  // List<Course> get myCourses => _myCourses;
  // Course? get selectedCourse => _selectedCourse;
  // bool get isLoading => _isLoading;
  // bool get isEnrolling => _isEnrolling;
  // String? get errorMessage => _errorMessage;
  // Map<String, dynamic> get courseProgress => _courseProgress;

  // Set auth token for API calls
  void setAuthToken(String token) {
    // _courseService.setAuthToken(token);
  }

  // Load all courses
  // Future<void> loadCourses({int page = 1, int limit = 20, String? category}) async {
  //   _setLoading(true);
  //   _clearError();
  //
  //   try {
  //     final courses = await _courseService.getCourses(
  //       page: page,
  //       limit: limit,
  //       category: category,
  //     );
  //
  //     if (page == 1) {
  //       _courses = courses;
  //     } else {
  //       _courses.addAll(courses);
  //     }
  //
  //     notifyListeners();
  //   } catch (e) {
  //     _setError('Failed to load courses: ${e.toString()}');
  //   } finally {
  //     _setLoading(false);
  //   }
  // }
  Future<void> loadCourses() async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1)); // fake loading

    _courses = [
      Course(
        id: "1",
        title: "Flutter for Beginners",
        description: "Learn the basics of Flutter with hands-on projects.",
        categories: ["Mobile", "Programming"],
        price: 49.99,
        duration: Duration(days: 4), // ✅ Correct
        instructorId: "101",
        instructorName: "John Doe",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Course(
        id: "2",
        title: "Advanced Dart",
        description: "Deep dive into Dart language features.",
        categories: ["Programming"],
        price: 59.99,
        duration: Duration(days: 6), // ✅ Correct
        instructorId: "102",
        instructorName: "Alice Smith",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Course(
        id: "3",
        title: "UI/UX Design",
        description: "Learn design principles for mobile and web apps.",
        categories: ["Design"],
        price: 39.99,
        duration: Duration(days: 3), // ✅ Correct
        instructorId: "103",
        instructorName: "Emily Johnson",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];


    _setLoading(false);
    notifyListeners();
  }

  // Load course details
  // Future<void> loadCourseDetails(String courseId) async {
  //   _setLoading(true);
  //   _clearError();
  //
  //   try {
  //     _selectedCourse = await _courseService.getCourseDetails(courseId);
  //     notifyListeners();
  //   } catch (e) {
  //     _setError('Failed to load course details: ${e.toString()}');
  //   } finally {
  //     _setLoading(false);
  //   }
  // }
  // Load dummy course details
  // Select a course by ID
  void selectCourse(String courseId) {
    try {
      _selectedCourse = _courses.firstWhere(
            (c) => c.id.toString() == courseId,
        orElse: () => throw Exception("Course not found"),
      );
      notifyListeners();
    } catch (e) {
      debugPrint("⚠️ Course with ID $courseId not found: $e");
    }
  }

  Future<void> loadCourseDetails(String courseId) async {
    _setLoading(true);
    _clearError();

    // CRITICAL FIX: Ensure the master list of courses is loaded before searching.
    if (_allCourses.isEmpty) {
      debugPrint("Master course list is empty. Loading all courses first...");
      await loadCourses(); // This will load the list and set loading to false.
      // We need to set loading back to true for the detail view loading state.
      _setLoading(true);
    }

    try {
      _selectedCourse = _allCourses.firstWhere(
            (course) => course.id == courseId,
      );
    } catch (e) {
      _setError('Course with ID "$courseId" not found.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> retryLoadCourseDetails(String courseId) async {
    _clearError();
    await loadCourseDetails(courseId);
  }


  // Enroll in a course
  // Future<bool> enrollInCourse(String courseId) async {
  //   _setEnrolling(true);
  //   _clearError();
  //
  //   try {
  //     final success = await _courseService.enrollInCourse(courseId);
  //
  //     if (success) {
  //       // Refresh course details to update enrollment status
  //       await loadCourseDetails(courseId);
  //       // Refresh my courses list
  //       await loadMyCourses();
  //     }
  //
  //     return success;
  //   } catch (e) {
  //     _setError('Failed to enroll in course: ${e.toString()}');
  //     return false;
  //   } finally {
  //     _setEnrolling(false);
  //   }
  // }
  Future<bool> enrollInCourse(String courseId) async {
    _myCourses.add(_courses.firstWhere((c) => c.id == courseId));
    notifyListeners();
    return true;
  }

  // Load user's enrolled courses
  Future<void> loadMyCourses() async {
    _setLoading(true);
    _clearError();
    await Future.delayed(const Duration(seconds: 1));

    // FIX: Add a sample course to the "My Courses" list.
    // In a real app, this would come from an API.
    if (_courses.isNotEmpty) {
      // Let's assume the user is enrolled in the first course from the full list.
      _myCourses = [_courses.first];
    }

    _setLoading(false);
    // No need for notifyListeners() here as _setLoading already calls it.
    // try {
    //   _myCourses = await _courseService.getMyCourses();
    //   notifyListeners();
    // } catch (e) {
    //   _setError('Failed to load enrolled courses: ${e.toString()}');
    // } finally {
    //   _setLoading(false);
    // }
  }

  // Mark lesson as completed
  Future<bool> markLessonCompleted(String courseId, String moduleId, String lessonId) async {
    _clearError();

    try {
      await Future.delayed(const Duration(milliseconds: 300)); // fake delay

      _courseProgress = {
        "completedLessons": (_courseProgress["completedLessons"] ?? 0) + 1,
        "totalLessons": _courseProgress["totalLessons"] ?? 10,
        "progress": "${(((_courseProgress["completedLessons"] ?? 0) + 1) / 10 * 100).toInt()}%"
      };
      notifyListeners();
      return true;

      // if (success) {
      //   // Refresh course progress
      //   await loadCourseProgress(courseId);
      //   // Refresh course details to update completion status
      //   if (_selectedCourse?.id == courseId) {
      //     await loadCourseDetails(courseId);
      //   }
      // }

      // return success;
    } catch (e) {
      _setError('Failed to mark lesson as completed: ${e.toString()}');
      return false;
    }


  }

  // Load course progress
  // Future<void> loadCourseProgress(String courseId) async {
  //   _clearError();
  //
  //   try {
  //     _courseProgress = await _courseService.getCourseProgress(courseId);
  //     notifyListeners();
  //   } catch (e) {
  //     _setError('Failed to load course progress: ${e.toString()}');
  //   }
  // }
  // Dummy course progress
  Future<void> loadCourseProgress(String courseId) async {
    _courseProgress = {
      "completedLessons": 3,
      "totalLessons": 10,
      "progress": "30%"
    };
    notifyListeners();
  }

  // Search courses by title or description
  List<Course> searchCourses(String query) {
    if (query.isEmpty) return _courses;

    return _courses.where((course) {
      final title = course.title.toLowerCase();
      final description = course.description.toLowerCase();
      final searchQuery = query.toLowerCase();

      return title.contains(searchQuery) || description.contains(searchQuery);
    }).toList();
  }

  // Filter courses by category
  List<Course> filterCoursesByCategory(String category) {
    if (category.isEmpty) return _courses;

    return _courses.where((course) {
      return course.categories.contains(category);
    }).toList();
  }

  // Helper methods to update state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setEnrolling(bool enrolling) {
    _isEnrolling = enrolling;
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