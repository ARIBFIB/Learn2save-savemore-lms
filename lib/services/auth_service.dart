import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_endpoints.dart';
import '../models/user_model.dart';

class AuthService {
  final String _baseUrl = ApiEndpoints.zohoCreatorBaseUrl;
  String? _authToken;
  User? _currentUser;

  // Getters
  String? get authToken => _authToken;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _authToken != null && _currentUser != null;

  // Initialize service by checking for stored auth token
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      _authToken = token;
      // Validate token by fetching user profile
      try {
        await fetchUserProfile();
      } catch (e) {
        // Token is invalid, clear it
        await clearAuthData();
      }
    }
  }

  // Login with email and password
  Future<User> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl${ApiEndpoints.login}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authToken = data['token'];
        _currentUser = User.fromJson(data['user']);

        // Store auth token locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _authToken!);

        return _currentUser!;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login error: ${e.toString()}');
    }
  }

  // Register a new user
  Future<User> signup(String firstName, String lastName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl${ApiEndpoints.signup}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _authToken = data['token'];
        _currentUser = User.fromJson(data['user']);

        // Store auth token locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _authToken!);

        return _currentUser!;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Signup failed');
      }
    } catch (e) {
      throw Exception('Signup error: ${e.toString()}');
    }
  }

  // Fetch current user profile
  Future<User> fetchUserProfile() async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl${ApiEndpoints.userProfile}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentUser = User.fromJson(data);
        return _currentUser!;
      } else {
        throw Exception('Failed to fetch user profile');
      }
    } catch (e) {
      throw Exception('Profile fetch error: ${e.toString()}');
    }
  }

  // Update user profile
  Future<User> updateUserProfile(Map<String, dynamic> userData) async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl${ApiEndpoints.updateUserProfile}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentUser = User.fromJson(data);
        return _currentUser!;
      } else {
        throw Exception('Failed to update user profile');
      }
    } catch (e) {
      throw Exception('Profile update error: ${e.toString()}');
    }
  }

  // Logout user
  Future<void> logout() async {
    if (_authToken == null) return;

    try {
      await http.post(
        Uri.parse('$_baseUrl${ApiEndpoints.logout}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );
    } catch (e) {
      // Even if logout request fails, clear local data
    } finally {
      await clearAuthData();
    }
  }

  // Clear authentication data
  Future<void> clearAuthData() async {
    _authToken = null;
    _currentUser = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Refresh authentication token
  Future<bool> refreshToken() async {
    if (_authToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl${ApiEndpoints.refreshToken}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authToken = data['token'];

        // Update stored auth token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _authToken!);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}