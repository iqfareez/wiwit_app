import 'dart:async';

import 'package:chopper/chopper.dart';

import '../../models/wiwit_api/problem_details.dart';

class ProblemDetailsInterceptor implements Interceptor {
  const ProblemDetailsInterceptor();

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final response = await chain.proceed(chain.request);
    if (response.isSuccessful) return response;

    final error = response.error;
    throw error is ProblemDetails ? error : ChopperHttpException(response);
  }
}
