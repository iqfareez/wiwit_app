import 'package:chopper/chopper.dart';

import '../apis/auth_service.dart';
import '../apis/category_service.dart';
import '../apis/transaction_service.dart';

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
      converter: const JsonConverter(),
    );
  }
}
