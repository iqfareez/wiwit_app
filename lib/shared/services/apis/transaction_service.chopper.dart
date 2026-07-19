// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'transaction_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$TransactionService extends TransactionService {
  _$TransactionService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = TransactionService;

  @override
  Future<Response<dynamic>> getTransactions(
    String authorization, {
    int? page,
    int? perPage,
    String? type,
    int? categoryId,
    String? dateFrom,
    String? dateTo,
  }) {
    final Uri $url = Uri.parse('/api/v1/transactions');
    final Map<String, dynamic> $params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'type': type,
      'category_id': categoryId,
      'date_from': dateFrom,
      'date_to': dateTo,
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
  Future<Response<dynamic>> createTransaction(
    String authorization,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/api/v1/transactions');
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
  Future<Response<dynamic>> getTransaction(String authorization, int id) {
    final Uri $url = Uri.parse('/api/v1/transactions/${id}');
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
  Future<Response<dynamic>> updateTransaction(
    String authorization,
    int id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/api/v1/transactions/${id}');
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
  Future<Response<dynamic>> deleteTransaction(String authorization, int id) {
    final Uri $url = Uri.parse('/api/v1/transactions/${id}');
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
