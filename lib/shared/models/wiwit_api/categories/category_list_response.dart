import 'package:json_annotation/json_annotation.dart';

import '../pagination_meta.dart';
import 'category_response.dart';

part 'category_list_response.g.dart';

@JsonSerializable()
class CategoryListResponse {
  final List<CategoryResponse> data;
  final PaginationMeta meta;

  const CategoryListResponse({required this.data, required this.meta});

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryListResponseToJson(this);
}
