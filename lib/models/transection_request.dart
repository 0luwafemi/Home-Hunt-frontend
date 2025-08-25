import 'package:homehunt/models/transection_response.dart';

class TransactionRequest {
  final int propertyId;
  final TransactionType type;
  final double paymentAmount;
  final String description;

  TransactionRequest({
    required this.propertyId,
    required this.type,
    required this.paymentAmount,
    required this.description,
  });

  /// Deserialize from JSON
  factory TransactionRequest.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String?;
    final parsedType = TransactionType.values.firstWhere(
          (e) => e.name == typeString,
      orElse: () => TransactionType.SALE,
    );

    return TransactionRequest(
      propertyId: json['propertyId'] as int,
      type: parsedType,
      paymentAmount: (json['paymentAmount'] as num).toDouble(),
      description: json['description'] as String? ?? '',
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'type': type.name,
      'paymentAmount': paymentAmount,
      'description': description,
    };
  }

  /// Optional: Add copyWith for flexibility
  TransactionRequest copyWith({
    int? propertyId,
    TransactionType? type,
    double? paymentAmount,
    String? description,
  }) {
    return TransactionRequest(
      propertyId: propertyId ?? this.propertyId,
      type: type ?? this.type,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      description: description ?? this.description,
    );
  }
}
