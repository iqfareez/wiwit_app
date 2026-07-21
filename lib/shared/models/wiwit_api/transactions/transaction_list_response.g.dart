// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionListResponse _$TransactionListResponseFromJson(
  Map<String, dynamic> json,
) => TransactionListResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => TransactionResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TransactionListResponseToJson(
  TransactionListResponse instance,
) => <String, dynamic>{'data': instance.data, 'meta': instance.meta};
