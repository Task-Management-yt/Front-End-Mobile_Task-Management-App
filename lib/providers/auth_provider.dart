import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _token;
  Map<String, dynamic>? _userData;
  bool _isAuthenticated = false;

  String? get token => _token;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userData => _userData;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");
    if (_token != null) {
      _isAuthenticated = true;
      await fetchUserData();
    }
  }

  Future<Map<String, dynamic>> signUp(
    String email,
    String password,
    String username,
    String name,
  ) async {
    try {
      await _authService.signUp(
        email: email,
        password: password,
        username: username,
        name: name,
      );
      return {"status": true};
    } catch (e) {
      List<String> parts = e.toString().split(':');
      return {"status": false, "message": parts.last.trim()};
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _token = await _authService.signIn(email: email, password: password);
      _isAuthenticated = true;
      await _saveToken(_token!); // Simpan token ke SharedPreferences
      await fetchUserData(); // 🔥 Panggil fetchUserData setelah login
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  Future<void> fetchUserData() async {
    if (_token == null) return;
    try {
      _userData = await _authService.getCurrentUser(_token!);
      notifyListeners();
    } catch (e) {
      logout();
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  Future<void> logout() async {
    _authService.logout();
    _token = null;
    _userData = null;
    _isAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    notifyListeners();
  }
}
