import 'package:json_annotation/json_annotation.dart';

part 'add_category_request.g.dart';

@JsonSerializable()
class AddCategoryRequest {
  final String name;
  @JsonKey(name: 'is_active')
  final bool? isActive;

  AddCategoryRequest({required this.name, this.isActive = true});

  factory AddCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$AddCategoryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddCategoryRequestToJson(this);
}
