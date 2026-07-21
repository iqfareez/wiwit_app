import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

/// The login response model
@JsonSerializable()
class LoginResponse {
  final String token;
  @JsonKey(name: 'token_type')
  final String tokenType;
  final List<String> abilities;
  @JsonKey(name: 'expires_at')
  final String? expiresAt;

  const LoginResponse({
    required this.token,
    required this.tokenType,
    required this.abilities,
    this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
