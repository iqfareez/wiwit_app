import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants.dart';

class AuthInterceptor implements Interceptor {
  final FlutterSecureStorage storage;

  AuthInterceptor(this.storage);

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final token = await storage.read(key: kStoreApiBearerToken);

    if (token == null) {
      return chain.proceed(chain.request);
    }

    return chain.proceed(
      applyHeader(chain.request, 'Authorization', 'Bearer $token'),
    );
  }
}
