class Location {
  final String city;
  final String state;
  final String country;

  Location({
    required this.city,
    required this.state,
    required this.country,
  });

  /// Create a Location from JSON (from Spring Boot backend)
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
    );
  }

  /// Convert Location to JSON (for sending to backend)
  Map<String, dynamic> toJson() => {
    'city': city,
    'state': state,
    'country': country,
  };

  /// Optional: override toString for debugging
  @override
  String toString() => 'Location(city: $city, state: $state, country: $country)';
}
