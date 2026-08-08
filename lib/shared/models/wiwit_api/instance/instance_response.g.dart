// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstanceResponse _$InstanceResponseFromJson(Map<String, dynamic> json) =>
    InstanceResponse(
      application: json['application'] as String,
      instanceName: json['instance_name'] as String,
      version: Version.fromJson(json['version'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InstanceResponseToJson(InstanceResponse instance) =>
    <String, dynamic>{
      'application': instance.application,
      'instance_name': instance.instanceName,
      'version': instance.version,
    };

Version _$VersionFromJson(Map<String, dynamic> json) => Version(
  display: json['display'] as String?,
  releaseTag: json['release_tag'] as String?,
  refName: json['ref_name'] as String?,
  commitSha: json['commit_sha'] as String,
  repositoryUrl: json['repository_url'] as String,
);

Map<String, dynamic> _$VersionToJson(Version instance) => <String, dynamic>{
  'display': instance.display,
  'release_tag': instance.releaseTag,
  'ref_name': instance.refName,
  'commit_sha': instance.commitSha,
  'repository_url': instance.repositoryUrl,
};
