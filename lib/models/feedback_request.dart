class FeedbackRequest {
  final int propertyId;
  final int userId;
  final String comment;
  final int rating; // scale of 1–5

  FeedbackRequest({
    required this.propertyId,
    required this.userId,
    required this.comment,
    required this.rating,
  });

  factory FeedbackRequest.fromJson(Map<String, dynamic> json) {
    return FeedbackRequest(
      propertyId: json['propertyId'],
      userId: json['userId'],
      comment: json['comment'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'userId': userId,
      'comment': comment,
      'rating': rating,
    };
  }
}
