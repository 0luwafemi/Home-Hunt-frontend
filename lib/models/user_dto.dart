enum Role { AGENT, BUYER }

extension RoleExtension on Role {
  String toJson() => roleToString(this);

  static Role fromString(String value) {
    return Role.values.firstWhere(
          (r) => roleToString(r).toLowerCase() == value.toLowerCase(),
      orElse: () => Role.BUYER,
    );
  }
}

String roleToString(Role role) {
  switch (role) {
    case Role.AGENT:
      return 'AGENT';
    case Role.BUYER:
      return 'BUYER';
  }
}

class UserDTO {
  final String firstName;
  final String lastName;
  final String address;
  final String phoneNumber;
  final String email;
  final String gender;
  final String country;
  final String language;
  final String password;
  final Role role;
  final String? localDate; // Optional ISO 8601 format

  const UserDTO({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.gender,
    required this.country,
    required this.language,
    required this.password,
    required this.role,
    this.localDate,
  });

  Map<String, dynamic> toJson({bool includePassword = true}) => {
    'firstName': firstName,
    'lastName': lastName,
    'address': address,
    'phoneNumber': phoneNumber,
    'email': email,
    'gender': gender,
    'country': country,
    'language': language,
    if (includePassword) 'password': password,
    'role': role.toJson(),
    if (localDate != null) 'localDate': localDate,
  };

  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
    firstName: json['firstName'] ?? '',
    lastName: json['lastName'] ?? '',
    address: json['address'] ?? '',
    phoneNumber: json['phoneNumber'] ?? '',
    email: json['email'] ?? '',
    gender: json['gender'] ?? '',
    country: json['country'] ?? '',
    language: json['language'] ?? '',
    password: json['password'] ?? '',
    role: RoleExtension.fromString(json['role'] ?? 'BUYER'),
    localDate: json['localDate'],
  );
}
