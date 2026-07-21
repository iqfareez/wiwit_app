import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/wiwit_api/auth/login_response.dart';
import '../../models/wiwit_api/categories/category_list_response.dart';
import '../../models/wiwit_api/categories/category_response.dart';
import '../../models/wiwit_api/transactions/transaction_list_response.dart';
import '../../models/wiwit_api/transactions/transaction_response.dart';
import '../apis/auth_service.dart';
import '../apis/category_service.dart';
import '../apis/transaction_service.dart';
import 'auth_interceptor.dart';
import 'json_serializable_converter.dart';

/// The Chopper Instance Singleton
/// Usage: ChopperInstance.client!...
class ChopperInstance {
  static final ChopperInstance _singleton = ChopperInstance._internal();

  factory ChopperInstance() {
    return _singleton;
  }

  ChopperInstance._internal();

  static ChopperClient? client;

  static void initializeChopperClient() {
    client ??= ChopperClient(
      baseUrl: Uri.parse('https://wiwit-staging.iqfareez.com'),
      services: [
        AuthService.create(),
        CategoryService.create(),
        TransactionService.create(),
      ],
      converter: JsonSerializableConverter({
        LoginResponse: LoginResponse.fromJson,
        CategoryListResponse: CategoryListResponse.fromJson,
        CategoryResponse: CategoryResponse.fromJson,
        TransactionListResponse: TransactionListResponse.fromJson,
        TransactionResponse: TransactionResponse.fromJson,
      }),
      interceptors: [AuthInterceptor(const FlutterSecureStorage())],
    );
  }
}
