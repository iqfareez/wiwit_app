// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      token: json['token'] as String,
      tokenType: json['token_type'] as String,
      abilities: (json['abilities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      expiresAt: json['expires_at'] as String?,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'token_type': instance.tokenType,
      'abilities': instance.abilities,
      'expires_at': instance.expiresAt,
    };
