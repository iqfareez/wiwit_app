import 'package:chopper/chopper.dart';

part 'category_service.chopper.g.dart';

@ChopperApi(baseUrl: '/api/v1/categories')
abstract class CategoryService extends ChopperService {
  static CategoryService create([ChopperClient? client]) =>
      _$CategoryService(client);

  @GET()
  Future<Response> getCategories({
    @Query() int? page,
    @Query('per_page') int? perPage,
    @Query('is_active') bool? isActive,
  });

  @POST()
  Future<Response> createCategory(@Body() Map<String, dynamic> body);

  @GET(path: '/{id}')
  Future<Response> getCategory(@Path() int id);

  @PATCH(path: '/{id}')
  Future<Response> updateCategory(
    @Path() int id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE(path: '/{id}')
  Future<Response> deleteCategory(@Path() int id);
}
