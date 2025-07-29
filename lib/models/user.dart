import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String username;
  final String email;
  final String role;
  final bool isVerified;
  final bool isApproved;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.isVerified,
    this.isApproved = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class RegisterRequest {
  final String username;
  final String email;
  final String password;
  final String role;
  final String? professorEmail;

  RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.professorEmail,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class OtpVerificationRequest {
  final String email;
  final String otp;

  OtpVerificationRequest({
    required this.email,
    required this.otp,
  });

  factory OtpVerificationRequest.fromJson(Map<String, dynamic> json) => _$OtpVerificationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OtpVerificationRequestToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final String token;
  final User user;

  LoginResponse({
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class ApiResponse {
  final bool success;
  final String message;

  ApiResponse({
    required this.success,
    required this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => _$ApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}