import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/property_dto.dart';
import '../models/property_search_criteria.dart';

class PropertySearchService {
  final String _baseUrl = 'http://10.0.2.2:8080/api/properties';

  Future<List<PropertyDto>> search(PropertySearchCriteria criteria, int page, int size) async {
    final url = Uri.parse('$_baseUrl/search?page=$page&size=$size');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(criteria.toJson());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch properties: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final List<dynamic> content = data['content'];
    return content.map((json) => PropertyDto.fromJson(json)).toList();
  }
}
