import 'package:flutter/material.dart';
import '../models/transection_request.dart';
import '../models/transection_response.dart';
import '../services/transection_service.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionService _service;
  TransactionProvider(this._service);

  bool _isProcessing = false;
  String? _error;
  TransactionResponse? _response;

  bool get isProcessing => _isProcessing;
  String? get error => _error;
  TransactionResponse? get response => _response;

  Future<void> processTransaction(TransactionRequest request, int userId) async {
    _isProcessing = true;
    _error = null;
    _response = null;
    notifyListeners();

    try {
      _response = await _service.processTransaction(request, userId);
    } catch (e) {
      _error = e.toString();
    }

    _isProcessing = false;
    notifyListeners();
  }

  void resetState() {
    _isProcessing = false;
    _error = null;
    _response = null;
    notifyListeners();
  }
}
