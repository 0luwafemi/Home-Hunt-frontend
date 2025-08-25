import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/login_dto.dart';
import '../models/user_dto.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _token;
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;

  UserDTO? _user;

  UserDTO? get user => _user;

  // Call this after login or API fetch
  void setUser(UserDTO user) {
    _user = user;
    notifyListeners();
  }

  // Optional: clear user on logout
  void clearUser() {
    _user = null;
    notifyListeners();
  }

  /// Registers a new user
  Future<void> register(UserDTO user) async {
    try {
      final response = await _authService.register(user);
      // You can show a success message or auto-login here if needed
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  /// Logs the user in and stores the token
  Future<void> login(LoginDTO dto) async {
    try {
      final fetchedToken = await _authService.login(dto);
      _token = fetchedToken;
      _isAuthenticated = true;
      await _storage.write(key: 'authToken', value: _token);
      notifyListeners();
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  /// Logs the user out and clears token
  Future<void> logout() async {
    _token = null;
    _isAuthenticated = false;
    await _storage.delete(key: 'authToken');
    notifyListeners();
  }

  /// Auto-login using stored token
  Future<void> tryAutoLogin() async {
    final storedToken = await _storage.read(key: 'authToken');
    if (storedToken != null) {
      _token = storedToken;
      _isAuthenticated = true;
      notifyListeners();
    }
  }
}
