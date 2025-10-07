import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class LocalStorageService {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';
  static const String _themeKey = 'theme_mode';

  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // User Management
  Future<void> saveUser(User user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  User? getUser() {
    final userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> removeUser() async {
    await _prefs.remove(_userKey);
  }

  // Authentication Token
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }

  // Theme Management
  Future<void> saveThemeMode(String theme) async {
    await _prefs.setString(_themeKey, theme);
  }

  String? getThemeMode() {
    return _prefs.getString(_themeKey);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}