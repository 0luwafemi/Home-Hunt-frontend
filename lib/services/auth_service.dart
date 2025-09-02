import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_dto.dart';
import '../models/reg_response.dart';
import '../models/user_dto.dart';

class AuthService {
  final String _baseUrl = 'http://10.0.2.2:8080/api/auth';

  Future<RegResponse> register(UserDTO user) async {
    final url = Uri.parse('$_baseUrl/register');
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return RegResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  Future<String> login(LoginDTO dto) async {
    final url = Uri.parse('$_baseUrl/login');
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<bool> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('$_baseUrl/change-password');
    final body = jsonEncode({
      'email': email,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to change password: ${response.body}');
    }
  }

  Future<bool> forgotPassword({
    required String email,
    required String newPassword,
  }) async {
    final url = Uri.parse('$_baseUrl/forgot-password');
    final body = jsonEncode({
      'email': email,
      'newPassword': newPassword,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to reset password: ${response.body}');
    }
  }

  Future<String> resendToken(String resendToken) async {
    final url = Uri.parse('$_baseUrl/resend-token');
    final body = jsonEncode({'resendToken': resendToken});

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Assuming the token is returned as plain string
    } else {
      throw Exception('Failed to resend token: ${response.body}');
    }
  }

}
