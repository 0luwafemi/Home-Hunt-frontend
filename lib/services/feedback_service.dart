import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/feedback_request.dart';

class FeedbackService {
  final String _baseUrl = 'http://10.0.2.2:8080/api/feedback';

  Future<void> submitFeedback(FeedbackRequest request) async {
    final url = Uri.parse('$_baseUrl/submit');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(request.toJson());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Failed to submit feedback: ${response.body}');
    }
  }
}
