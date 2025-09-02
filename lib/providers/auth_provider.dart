import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/login_dto.dart';
import '../models/user_dto.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final String _baseUrl = 'http://your-api-url.com/api/auth'; //  FIXED: Declare base URL

  String? _token;
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserDTO? _user;
  UserDTO? get user => _user;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setUser(UserDTO user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  /// Registers a new user
  Future<void> register(UserDTO user) async {
    try {
      await _authService.register(user);
    } catch (e) {
      _setError('Registration error: $e');
      rethrow;
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
      _setError('Login error: $e');
      rethrow;
    }
  }

  /// Logs the user out and clears token
  Future<void> logout() async {
    _token = null;
    _isAuthenticated = false;
    await _storage.delete(key: 'authToken');
    clearUser();
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

  Future<bool> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _setError(null);

    final url = Uri.parse('$_baseUrl/change-password');
    final body = jsonEncode({
      'email': email,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      _setLoading(false);

      if (response.statusCode == 200) {
        return true;
      } else {
        _setError('Failed to change password: ${response.body}');
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setError('Error: $e');
      return false;
    }
  }

  Future<bool> forgotPassword({
    required String email,
    required String newPassword,
  }) async {
    _setLoading(true);
    _setError(null);

    final url = Uri.parse('$_baseUrl/forgot-password');
    final body = jsonEncode({
      'email': email,
      'newPassword': newPassword,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      _setLoading(false);

      if (response.statusCode == 200) {
        return true;
      } else {
        _setError('Failed to reset password: ${response.body}');
        return false;
      }
    } catch (e) {
      _setLoading(false);
      _setError('Error: $e');
      return false;
    }
  }

  Future<String?> resendToken(String resendToken) async {
    _setLoading(true);
    _setError(null);

    final url = Uri.parse('$_baseUrl/resend-token');
    final body = jsonEncode({'resendToken': resendToken});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      _setLoading(false);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        _setError('Failed to resend token: ${response.body}');
        return null;
      }
    } catch (e) {
      _setLoading(false);
      _setError('Error: $e');
      return null;
    }
  }
}

