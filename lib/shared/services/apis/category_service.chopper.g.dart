// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'category_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$CategoryService extends CategoryService {
  _$CategoryService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = CategoryService;

  @override
  Future<Response<CategoryListResponse>> getCategories({
    int? page,
    int? perPage,
    bool? showInactive,
  }) {
    final Uri $url = Uri.parse('/api/v1/categories');
    final Map<String, dynamic> $params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'show_inactive': showInactive,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<CategoryListResponse, CategoryListResponse>($request);
  }

  @override
  Future<Response<CategoryResponse>> createCategory(AddCategoryRequest body) {
    final Uri $url = Uri.parse('/api/v1/categories');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<CategoryResponse, CategoryResponse>($request);
  }

  @override
  Future<Response<CategoryResponse>> getCategory(int id) {
    final Uri $url = Uri.parse('/api/v1/categories/${id}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<CategoryResponse, CategoryResponse>($request);
  }

  @override
  Future<Response<dynamic>> updateCategory(int id, UpdateCategoryRequest body) {
    final Uri $url = Uri.parse('/api/v1/categories/${id}');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteCategory(int id) {
    final Uri $url = Uri.parse('/api/v1/categories/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
