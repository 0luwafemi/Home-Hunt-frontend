import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/transection_request.dart';
import '../models/transection_response.dart';

class TransactionService {
  final String _baseUrl = 'http://10.0.2.2:8080/api/transactions';

  Future<TransactionResponse> processTransaction(
      TransactionRequest request, int userId) async {
    final url = Uri.parse('$_baseUrl/process?userId=$userId');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(request.toJson());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return TransactionResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Transaction failed: ${response.body}');
    }
  }
}
