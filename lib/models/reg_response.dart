import 'dart:convert';

class RegResponse {
  final String status;        // "SUCCESS", "ERROR"
  final String message;       // Detailed message or error
  final String? token;        // JWT token, optional
  final DateTime? timestamp;  // Optional response time
  final dynamic data;         // Any extra payload (User, Map, etc.)

  const RegResponse({
    required this.status,
    required this.message,
    this.token,
    this.timestamp,
    this.data,
  });

  /// Deserialize from JSON
  factory RegResponse.fromJson(Map<String, dynamic> json) {
    return RegResponse(
      status: json['status'] as String? ?? 'ERROR',
      message: json['message'] as String? ?? 'Unknown error',
      token: json['token'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'])
          : null,
      data: json['data'],
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'token': token,
      'timestamp': timestamp?.toIso8601String(),
      'data': data,
    };
  }

  /// Optional: Convert to JSON string
  String toJsonString() => jsonEncode(toJson());

  /// Optional: Create a copy with modified fields
  RegResponse copyWith({
    String? status,
    String? message,
    String? token,
    DateTime? timestamp,
    dynamic data,
  }) {
    return RegResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      token: token ?? this.token,
      timestamp: timestamp ?? this.timestamp,
      data: data ?? this.data,
    );
  }
}

//
// class RegResponse {
//   final String status;        // "SUCCESS", "ERROR"
//   final String message;       // Detailed message or error
//   final String? token;        // JWT token, optional
//   final DateTime? timestamp;  // Optional response time
//   final dynamic data;         // Any extra payload (User, Map, etc.)
//
//
//   RegResponse({
//     required this.status,
//     required this.message,
//     this.token,
//     this.timestamp,
//     this.data,
//   });
//
//   factory RegResponse.fromJson(Map<String, dynamic> json) {
//     return RegResponse(
//       status: json['status'],
//       message: json['message'],
//       token: json['token'],
//       timestamp: json['timestamp'] != null
//           ? DateTime.parse(json['timestamp'])
//           : null,
//       data: json['data'], // Can be null, Map, or nested object
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'message': message,
//       'token': token,
//       'timestamp': timestamp?.toIso8601String(),
//       'data': data,
//     };
//   }
//
// }
//
