import 'package:json_annotation/json_annotation.dart';

import '../enums.dart';

part 'transaction_response.g.dart';

@JsonSerializable()
class TransactionResponse {
  final int id;
  final String title;
  final TransactionType type;
  final String amount;
  final TransactionCategoryResponse? category;
  final String? notes;
  @JsonKey(name: 'transaction_date')
  final DateTime transactionDate;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const TransactionResponse({
    required this.id,
    required this.title,
    required this.type,
    required this.amount,
    required this.category,
    required this.notes,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);

  @override
  String toString() =>
      'TransactionResponse(id: $id, title: $title, type: $type, amount: $amount, category: $category, notes: $notes, transactionDate: $transactionDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}

@JsonSerializable()
class TransactionCategoryResponse {
  final int id;
  final String name;
  @JsonKey(name: 'is_active')
  final bool isActive;

  const TransactionCategoryResponse({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory TransactionCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionCategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionCategoryResponseToJson(this);
}
