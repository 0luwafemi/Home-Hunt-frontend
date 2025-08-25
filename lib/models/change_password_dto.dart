class ChangePasswordDto {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final String email;

  ChangePasswordDto({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
    required this.email,
  });

  factory ChangePasswordDto.fromJson(Map<String, dynamic> json) {
    return ChangePasswordDto(
      currentPassword: json['currentPassword'],
      newPassword: json['newPassword'],
      confirmPassword: json['confirmPassword'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'email': email,
      'confirmPassword': confirmPassword,
    };
  }
}