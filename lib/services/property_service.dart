import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/property_dto.dart';
import '../models/property_response.dart';

class PropertyService {
  final String baseUrl = 'http://10.0.2.2:8080/api/properties'; // Use your actual endpoint

  // 🔍 List All Properties
  Future<List<PropertyDto>> listAll() async {
    final response = await http.get(Uri.parse('$baseUrl/all'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => PropertyDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load properties');
    }
  }

  // 📤 Post New Property
  Future<PropertyDto> postProperty(PropertyDto dto, int agentId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/post?agentId=$agentId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode == 200) {
      return PropertyDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to post property');
    }
  }

  // ✏️ Update Property
  Future<PropertyDto> updateProperty(int agentId, PropertyDto dto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$agentId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode == 200) {
      return PropertyDto.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update property');
    }
  }

  // 🛏 Rent Property
  Future<PropertyResponse> rentProperty(int propertyId, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rent/$propertyId/$userId'),
    );

    if (response.statusCode == 200) {
      return PropertyResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Rent failed: ${response.body}');
    }
  }

  // 💰 Buy Property
  Future<PropertyResponse> buyProperty(int propertyId, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/buy/$propertyId/$userId'),
    );

    if (response.statusCode == 200) {
      return PropertyResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Purchase failed: ${response.body}');
    }
  }
}
