import 'package:flutter/material.dart';
import '../models/property_dto.dart';
import '../models/property_response.dart';
import '../services/property_service.dart';

class PropertyProvider extends ChangeNotifier {
  final PropertyService _service;
  PropertyProvider(this._service);

  List<PropertyDto> _properties = [];
  bool _isLoading = false;
  String? _error;
  PropertyResponse? _lastActionResult;

  List<PropertyDto> get properties => _properties;
  bool get isLoading => _isLoading;
  String? get error => _error;
  PropertyResponse? get lastActionResult => _lastActionResult;

  Future<void> fetchAllProperties() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _properties = await _service.listAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> postProperty(PropertyDto dto, int agentId) async {
    try {
      final result = await _service.postProperty(dto, agentId);
      _properties.add(result);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateProperty(PropertyDto dto, int agentId) async {
    try {
      final updated = await _service.updateProperty(agentId, dto);
      final index = _properties.indexWhere((p) => p.id == updated.id);
      if (index != -1) {
        _properties[index] = updated;
        _error = null;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> rentProperty(int propertyId, int userId) async {
    try {
      _lastActionResult = await _service.rentProperty(propertyId, userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> buyProperty(int propertyId, int userId) async {
    try {
      _lastActionResult = await _service.buyProperty(propertyId, userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
