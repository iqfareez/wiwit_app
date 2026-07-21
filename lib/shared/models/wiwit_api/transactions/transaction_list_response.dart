import 'package:json_annotation/json_annotation.dart';

import '../pagination_meta.dart';
import 'transaction_response.dart';

part 'transaction_list_response.g.dart';

@JsonSerializable()
class TransactionListResponse {
  final List<TransactionResponse> data;
  final PaginationMeta meta;

  const TransactionListResponse({required this.data, required this.meta});

  factory TransactionListResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionListResponseToJson(this);
}
