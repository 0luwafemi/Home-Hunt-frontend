class PropertyResponse {
  final String status;
  final String message;
  final int? propertyId;
  final int? userId;
  final DateTime? timestamp;

  PropertyResponse({
    required this.status,
    required this.message,
    this.propertyId,
    this.userId,
    this.timestamp,
  });

  factory PropertyResponse.fromJson(Map<String, dynamic> json) {
    return PropertyResponse(
      status: json['status'],
      message: json['message'],
      propertyId: json['propertyId'],
      userId: json['userId'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'propertyId': propertyId,
      'userId': userId,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
