import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../constants/dummy_data.dart';
import '../services/local_storage_service.dart';

class AuthController extends ChangeNotifier {
  final LocalStorageService _storage;
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthController(SharedPreferences prefs) : _storage = LocalStorageService(prefs) {
    _loadUser();
  }

  // Getters
  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.role == 'admin';
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load user from local storage
  Future<void> _loadUser() async {
    _user = _storage.getUser();
    notifyListeners();
  }

  // Login with email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Dummy authentication logic for student
      if (email == 'savemore@gmail.com' && password == 'password123') {
        _user = DummyData.currentUser;
        await _storage.saveUser(_user!);
        await _storage.saveToken('dummy_token_${DateTime.now().millisecondsSinceEpoch}');
        _isLoading = false;
        notifyListeners();
        return true;
      }
      // Dummy authentication logic for admin
      else if (email == 'admin@savemore.com' && password == 'admin123') {
        _user = DummyData.adminUser;
        await _storage.saveUser(_user!);
        await _storage.saveToken('admin_token_${DateTime.now().millisecondsSinceEpoch}');
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Signup with user details
  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Create new user (dummy logic)
      _user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        avatar: 'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/200/200',
        bio: 'New learner passionate about growth',
        enrolledCourses: [],
        completedCourses: [],
        achievements: ['New Member'],
        joinDate: DateTime.now(),
        totalLearningHours: 0,
        role: 'student',
      );

      await _storage.saveUser(_user!);
      await _storage.saveToken('dummy_token_${DateTime.now().millisecondsSinceEpoch}');

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Signup failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _storage.removeUser();
      await _storage.removeToken();
      _user = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Logout failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}