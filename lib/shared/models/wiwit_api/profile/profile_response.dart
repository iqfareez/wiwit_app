import 'package:json_annotation/json_annotation.dart';

part 'profile_response.g.dart';

@JsonSerializable()
/// Represents the profile response.
class ProfileResponse {
  final int id;

  /// The user's name
  final String name;

  /// The user's email
  final String email;

  /// The user's profile photo URL.
  @JsonKey(name: 'profile_photo_url')
  final String? profilePhotoUrl;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  ProfileResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePhotoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);

  @override
  String toString() {
    return 'ProfileResponse(id: $id, name: $name, email: $email)';
  }
}
