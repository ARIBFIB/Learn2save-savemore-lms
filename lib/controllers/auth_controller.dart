import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService;

  AuthController(this._authService) {
    // Initialize auth state on controller creation
    _initializeAuth();
  }

  // Private state variables
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  String? get authToken => _user?.token;


  // Initialize authentication state
  Future<void> _initializeAuth() async {
    _setLoading(true);
    try {
      await _authService.initialize();
      _user = _authService.currentUser;
      notifyListeners();
    } catch (e) {
      _setError('Authentication initialization failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Login with email and password
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    clearError();

    try {
      _user = await _authService.login(email, password);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register a new user
  Future<bool> signup(String firstName, String lastName, String email, String password) async {
    _setLoading(true);
    clearError();

    try {
      _user = await _authService.signup(firstName, lastName, email, password);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Signup failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> userData) async {
    _setLoading(true);
    clearError();

    try {
      _user = await _authService.updateUserProfile(userData);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Profile update failed: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout user
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authService.logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      _setError('Logout failed: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Refresh authentication token
  Future<bool> refreshAuth() async {
    try {
      final success = await _authService.refreshToken();
      if (success) {
        _user = _authService.currentUser;
        notifyListeners();
      }
      return success;
    } catch (e) {
      _setError('Token refresh failed: ${e.toString()}');
      return false;
    }
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

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}