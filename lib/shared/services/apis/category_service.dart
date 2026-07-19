import 'package:chopper/chopper.dart';

part 'category_service.chopper.dart';

@ChopperApi(baseUrl: '/api/v1/categories')
abstract class CategoryService extends ChopperService {
  static CategoryService create([ChopperClient? client]) =>
      _$CategoryService(client);

  @GET()
  Future<Response> getCategories(
    @Header('Authorization') String authorization, {
    @Query() int? page,
    @Query('per_page') int? perPage,
    @Query('is_active') bool? isActive,
  });

  @POST()
  Future<Response> createCategory(
    @Header('Authorization') String authorization,
    @Body() Map<String, dynamic> body,
  );

  @GET(path: '/{id}')
  Future<Response> getCategory(
    @Header('Authorization') String authorization,
    @Path() int id,
  );

  @PATCH(path: '/{id}')
  Future<Response> updateCategory(
    @Header('Authorization') String authorization,
    @Path() int id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(path: '/{id}')
  Future<Response> deleteCategory(
    @Header('Authorization') String authorization,
    @Path() int id,
  );
}
