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
  Future<Response<dynamic>> getCategories(
    String authorization, {
    int? page,
    int? perPage,
    bool? isActive,
  }) {
    final Uri $url = Uri.parse('/api/v1/categories');
    final Map<String, dynamic> $params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'is_active': isActive,
    };
    final Map<String, String> $headers = {'Authorization': authorization};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createCategory(
    String authorization,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/api/v1/categories');
    final Map<String, String> $headers = {'Authorization': authorization};
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getCategory(String authorization, int id) {
    final Uri $url = Uri.parse('/api/v1/categories/${id}');
    final Map<String, String> $headers = {'Authorization': authorization};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateCategory(
    String authorization,
    int id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/api/v1/categories/${id}');
    final Map<String, String> $headers = {'Authorization': authorization};
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteCategory(String authorization, int id) {
    final Uri $url = Uri.parse('/api/v1/categories/${id}');
    final Map<String, String> $headers = {'Authorization': authorization};
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
