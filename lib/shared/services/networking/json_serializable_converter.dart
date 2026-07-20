import 'dart:async';

import 'package:chopper/chopper.dart';

typedef JsonFactory<T> = T Function(Map<String, dynamic> json);

class JsonSerializableConverter extends JsonConverter {
  final Map<Type, JsonFactory<dynamic>> factories;

  const JsonSerializableConverter(this.factories);

  T? _decodeMap<T>(Map<String, dynamic> values) {
    final factory = factories[T];
    if (factory == null) return null;
    return factory(values) as T;
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).cast<Map<String, dynamic>>().map((e) => _decodeMap<T>(e)!).toList();

  dynamic _decode<T>(dynamic entity) {
    if (entity is Iterable) return _decodeList<T>(entity);
    if (entity is Map) return _decodeMap<T>(entity as Map<String, dynamic>);
    return entity;
  }

  @override
  FutureOr<Response<ResultType>> convertResponse<ResultType, Item>(Response response) async {
    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(body: _decode<Item>(jsonRes.body));
  }

  @override
  Request convertRequest(Request request) {
    final body = request.body;
    if (body is Map || body is List) {
      return super.convertRequest(request);
    }
    if (body != null && body is! String) {
      final toJson = _toJson(body);
      if (toJson != null) {
        return super.convertRequest(request.copyWith(body: toJson));
      }
    }
    return super.convertRequest(request);
  }

  Map<String, dynamic>? _toJson(dynamic object) {
    try {
      final toJson = (object as dynamic).toJson;
      if (toJson is Map<String, dynamic> Function()) {
        return toJson();
      }
    } catch (_) {}
    return null;
  }
}
