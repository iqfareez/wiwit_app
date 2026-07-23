import 'dart:async';

import 'package:chopper/chopper.dart';

const _authorizationHeader = 'Authorization';

/// Stamps the current bearer token onto every outgoing request.
class AuthInterceptor implements Interceptor {
  AuthInterceptor(this.readToken);

  final Future<String?> Function() readToken;

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final token = await readToken();

    if (token == null || token.isEmpty) {
      return chain.proceed(chain.request);
    }

    return chain.proceed(
      applyHeader(chain.request, _authorizationHeader, 'Bearer $token'),
    );
  }
}
