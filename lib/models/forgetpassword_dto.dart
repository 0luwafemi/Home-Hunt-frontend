
class ForgotPasswordDto {
  final String email;
  final String newPassword;

  ForgotPasswordDto({
    required this.email,
    required this.newPassword,
  });

  factory ForgotPasswordDto.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordDto(
      email: json['email'],
      newPassword: json['newPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'newPassword': newPassword,
    };
  }
}