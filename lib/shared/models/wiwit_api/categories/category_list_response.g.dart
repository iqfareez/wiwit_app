// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryListResponse _$CategoryListResponseFromJson(
  Map<String, dynamic> json,
) => CategoryListResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => CategoryResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CategoryListResponseToJson(
  CategoryListResponse instance,
) => <String, dynamic>{'data': instance.data, 'meta': instance.meta};
