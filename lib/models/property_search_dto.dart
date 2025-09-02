import 'package:homehunt/models/property_dto.dart';

class PropertySearchDto {
  final String location;
  final PropertyType type;
  final double minPrice;
  final double maxPrice;
  final PropertyStatus status;

  PropertySearchDto({
    required this.location,
    required this.type,
    required this.minPrice,
    required this.maxPrice,
    required this.status,
  });

  factory PropertySearchDto.fromJson(Map<String, dynamic> json) {
    return PropertySearchDto(
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
