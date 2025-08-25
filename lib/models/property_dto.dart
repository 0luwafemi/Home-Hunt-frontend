import 'package:homehunt/models/location.dart';

enum PropertyStatus {
  AVAILABLE,
  SOLD,
  RENTED;

  static PropertyStatus fromString(String value) {
    return PropertyStatus.values.firstWhere(
          (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => PropertyStatus.AVAILABLE,
    );
  }
}

enum PropertyType {
  House,
  Apartment,
  Land;

  static PropertyType fromString(String value) {
    return PropertyType.values.firstWhere(
          (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => PropertyType.House,
    );
  }
}

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String role;
  final DateTime localDate;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.role,
    required this.localDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? 'user',
      localDate: DateTime.tryParse(json['localDate'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'password': password,
    'role': role,
    'localDate': localDate.toIso8601String(),
  };
}

class PropertyDto {
  final int id;
  final String title;
  final String description;
  final double price;
  final Location location;
  final PropertyStatus status;
  final PropertyType type;
  final User agent;
  final String imageUrl;
  final int bedrooms;
  final DateTime? createdAt;
  final bool isFeatured;

  PropertyDto({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.status,
    required this.type,
    required this.agent,
    required this.imageUrl,
    required this.bedrooms,
    this.createdAt,
    required this.isFeatured,
  });

  factory PropertyDto.fromJson(Map<String, dynamic> json) {
    return PropertyDto(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      location: Location.fromJson(json['location'] ?? {}),
      status: PropertyStatus.fromString(json['status'] ?? ''),
      type: PropertyType.fromString(json['type'] ?? ''),
      agent: User.fromJson(json['agent'] ?? {}),
      imageUrl: json['imageUrl'],
      bedrooms: json['bedrooms'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'price': price,
    'location': location.toJson(),
    'status': status.name,
    'type': type.name,
    'agent': agent.toJson(),
    'imageUrl': imageUrl,
    'bedrooms': bedrooms,
    'createdAt': createdAt?.toIso8601String(),
    'isFeatured': isFeatured,
  };
}
