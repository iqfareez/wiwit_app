import 'package:chopper/chopper.dart';

part 'transaction_service.chopper.dart';

@ChopperApi(baseUrl: '/api/v1/transactions')
abstract class TransactionService extends ChopperService {
  static TransactionService create([ChopperClient? client]) =>
      _$TransactionService(client);

  @GET()
  Future<Response> getTransactions(
    @Header('Authorization') String authorization, {
    @Query() int? page,
    @Query('per_page') int? perPage,
    @Query() String? type,
    @Query('category_id') int? categoryId,
    @Query('date_from') String? dateFrom,
    @Query('date_to') String? dateTo,
  });

  @POST()
  Future<Response> createTransaction(
    @Header('Authorization') String authorization,
    @Body() Map<String, dynamic> body,
  );

  @GET(path: '/{id}')
  Future<Response> getTransaction(
    @Header('Authorization') String authorization,
    @Path() int id,
  );

  @PATCH(path: '/{id}')
  Future<Response> updateTransaction(
    @Header('Authorization') String authorization,
    @Path() int id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(path: '/{id}')
  Future<Response> deleteTransaction(
    @Header('Authorization') String authorization,
    @Path() int id,
  );
}
