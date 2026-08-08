import 'package:json_annotation/json_annotation.dart';

part 'instance_response.g.dart';

@JsonSerializable()
class InstanceResponse {
  final String application;
  @JsonKey(name: 'instance_name')
  final String instanceName;
  final Version version;

  InstanceResponse({
    required this.application,
    required this.instanceName,
    required this.version,
  });

  factory InstanceResponse.fromJson(Map<String, dynamic> json) =>
      _$InstanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InstanceResponseToJson(this);
}

@JsonSerializable()
class Version {
  final String? display;
  @JsonKey(name: 'release_tag')
  final String? releaseTag;
  @JsonKey(name: 'ref_name')
  final String? refName;
  @JsonKey(name: 'commit_sha')
  final String commitSha;
  @JsonKey(name: 'repository_url')
  final String repositoryUrl;

  Version({
    required this.display,
    required this.releaseTag,
    required this.refName,
    required this.commitSha,
    required this.repositoryUrl,
  });

  factory Version.fromJson(Map<String, dynamic> json) =>
      _$VersionFromJson(json);

  Map<String, dynamic> toJson() => _$VersionToJson(this);
}
