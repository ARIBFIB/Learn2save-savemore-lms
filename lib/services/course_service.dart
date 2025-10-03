import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../models/course_model.dart';

class CourseService {
  final String _baseUrl = ApiEndpoints.zohoCreatorBaseUrl;
  String? _authToken;

  // Set auth token for authenticated requests
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Get all courses
  Future<List<Course>> getCourses({int page = 1, int limit = 20, String? category}) async {
    try {
      Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      final uri = Uri.parse('$_baseUrl${ApiEndpoints.courses}')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (_authToken != null) 'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> coursesJson = data['courses'] ?? [];
        return coursesJson.map((json) => Course.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      throw Exception('Error fetching courses: ${e.toString()}');
    }
  }

  // Get course details by ID
  Future<Course> getCourseDetails(String courseId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl${ApiEndpoints.courseDetails}$courseId'),
        headers: {
          'Content-Type': 'application/json',
          if (_authToken != null) 'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Course.fromJson(data);
      } else {
        throw Exception('Failed to load course details');
      }
    } catch (e) {
      throw Exception('Error fetching course details: ${e.toString()}');
    }
  }

  // Enroll in a course
  Future<bool> enrollInCourse(String courseId) async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl${ApiEndpoints.enrollCourse}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: jsonEncode({
          'course_id': courseId,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to enroll in course');
      }
    } catch (e) {
      throw Exception('Error enrolling in course: ${e.toString()}');
    }
  }

  // Get user's enrolled courses
  Future<List<Course>> getMyCourses() async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl${ApiEndpoints.myCourses}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> coursesJson = data['courses'] ?? [];
        return coursesJson.map((json) => Course.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load enrolled courses');
      }
    } catch (e) {
      throw Exception('Error fetching enrolled courses: ${e.toString()}');
    }
  }

  // Mark lesson as completed
  Future<bool> markLessonCompleted(String courseId, String moduleId, String lessonId) async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/courses/$courseId/modules/$moduleId/lessons/$lessonId/complete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to mark lesson as completed');
      }
    } catch (e) {
      throw Exception('Error marking lesson as completed: ${e.toString()}');
    }
  }

  // Get course progress
  Future<Map<String, dynamic>> getCourseProgress(String courseId) async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/courses/$courseId/progress'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load course progress');
      }
    } catch (e) {
      throw Exception('Error fetching course progress: ${e.toString()}');
    }
  }
}