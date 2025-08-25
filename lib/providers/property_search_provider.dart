import 'package:flutter/material.dart';
import '../models/property_dto.dart';
import '../models/property_search_criteria.dart';
import '../services/property_search_service.dart';

class PropertySearchProvider with ChangeNotifier {
  final PropertySearchService _service = PropertySearchService();

  List<PropertyDto> _results = [];
  bool _isLoading = false;
  String? _error;

  List<PropertyDto> get results => _results;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> search(PropertySearchCriteria criteria, {int page = 0, int size = 10}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final properties = await _service.search(criteria, page, size);
      _results = properties;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _results = [];
    _error = null;
    notifyListeners();
  }
}
