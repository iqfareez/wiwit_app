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

  /// Builds (or rebuilds) the shared client pointed at [baseUrl].
  static void initializeChopperClient(String baseUrl) {
    client?.dispose();
    client = ChopperClient(
      baseUrl: Uri.parse(baseUrl),
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

  /// Tears down the client, e.g. when the user switches to another server.
  static void reset() {
    client?.dispose();
    client = null;
  }

  /// Pings [baseUrl] to confirm the server is reachable.
  ///
  /// Any HTTP response (even 401/404) means the host answered, so it counts
  /// as reachable. Only connection failures or timeouts return `false`.
  static Future<bool> isServerReachable(String baseUrl) async {
    // TODO: Create an endpoint to verify it's the wiwit instances
    final probe = ChopperClient(baseUrl: Uri.parse(baseUrl));
    try {
      await probe.get(Uri.parse('/')).timeout(const Duration(seconds: 10));
      return true;
    } catch (_) {
      return false;
    } finally {
      probe.dispose();
    }
  }
}
