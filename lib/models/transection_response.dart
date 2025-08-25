enum TransactionType {
  SALE,
  RENT,
  PURCHASE,
  LEASE,
  // Add more as needed
}

extension TransactionTypeExtension on TransactionType {
  static TransactionType fromString(String type) {
    return TransactionType.values.firstWhere(
          (e) => e.name.toLowerCase() == type.trim().toLowerCase(),
      orElse: () => TransactionType.SALE,
    );
  }
}

class TransactionResponse {
  final String status;
  final String message;
  final int? propertyId;
  final int? userId;
  final TransactionType? transactionType;
  final DateTime? timestamp;
  final String? transactionId; // Optional: add if needed

  TransactionResponse({
    required this.status,
    required this.message,
    this.propertyId,
    this.userId,
    this.transactionType,
    this.timestamp,
    this.transactionId,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      propertyId: json['propertyId'] as int?,
      userId: json['userId'] as int?,
      transactionType: json['transactionType'] != null
          ? TransactionTypeExtension.fromString(json['transactionType'] as String)
          : null,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
      transactionId: json['transactionId'] as String?, // Optional
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'propertyId': propertyId,
      'userId': userId,
      'transactionType': transactionType?.name,
      'timestamp': timestamp?.toIso8601String(),
      if (transactionId != null) 'transactionId': transactionId,
    };
  }
}
