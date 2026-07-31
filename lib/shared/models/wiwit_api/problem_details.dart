import 'package:json_annotation/json_annotation.dart';

import 'enums.dart';

part 'problem_details.g.dart';

/// The error body returned by the Wiwit API
@JsonSerializable()
class ProblemDetails implements Exception {
  final ProblemDetailType type;
  final String title;
  final int status;
  final String detail;
  final String instance;
  final List<String>? errors;

  ProblemDetails({
    required this.type,
    required this.title,
    required this.status,
    required this.detail,
    required this.instance,
    this.errors,
  });

  factory ProblemDetails.fromJson(Map<String, dynamic> json) =>
      _$ProblemDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ProblemDetailsToJson(this);

  @override
  String toString() => 'ProblemDetails($status $title: $detail)';
}
