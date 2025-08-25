import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_dto.dart';
import '../models/reg_response.dart';
import '../models/user_dto.dart';

class AuthService {
  final String _baseUrl = 'http://10.0.2.2:8080/api/auth'; // Update as needed

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
}
