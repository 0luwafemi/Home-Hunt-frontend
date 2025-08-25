
import 'package:homehunt/models/property_dto.dart';

class PropertySearchCriteria {
  final String location;
  final PropertyType type; // Could be a custom enum: PropertyType
  final double minPrice;
  final double maxPrice;
  final PropertyStatus status; // Could be a custom enum: PropertyStatus

  PropertySearchCriteria({
    required this.location,
    required this.type,
    required this.minPrice,
    required this.maxPrice,
    required this.status,
  });

  factory PropertySearchCriteria.fromJson(Map<String, dynamic> json) {
    return PropertySearchCriteria(
      location: json['location'],
      type: json['type'],
      minPrice: (json['minPrice'] as num).toDouble(),
      maxPrice: (json['maxPrice'] as num).toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'type': type,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'status': status,
    };
  }
}
