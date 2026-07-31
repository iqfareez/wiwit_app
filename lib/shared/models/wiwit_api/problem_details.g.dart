// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProblemDetails _$ProblemDetailsFromJson(Map<String, dynamic> json) =>
    ProblemDetails(
      type: $enumDecode(_$ProblemDetailTypeEnumMap, json['type']),
      title: json['title'] as String,
      status: (json['status'] as num).toInt(),
      detail: json['detail'] as String,
      instance: json['instance'] as String,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ProblemDetailsToJson(ProblemDetails instance) =>
    <String, dynamic>{
      'type': _$ProblemDetailTypeEnumMap[instance.type]!,
      'title': instance.title,
      'status': instance.status,
      'detail': instance.detail,
      'instance': instance.instance,
      'errors': instance.errors,
    };

const _$ProblemDetailTypeEnumMap = {
  ProblemDetailType.malformedJson: '/problems/malformed-json',
  ProblemDetailType.unauthenticated: '/problems/unauthenticated',
  ProblemDetailType.insufficientAbility: '/problems/insufficient-ability',
  ProblemDetailType.notFound: '/problems/not-found',
  ProblemDetailType.conflict: '/problems/conflict',
  ProblemDetailType.unsupportedMediaType: '/problems/unsupported-media-type',
  ProblemDetailType.validationFailed: '/problems/validation-failed',
  ProblemDetailType.tooManyRequests: '/problems/too-many-requests',
  ProblemDetailType.internalServerError: '/problems/internal-server-error',
};
