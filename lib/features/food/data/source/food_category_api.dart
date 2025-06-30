import 'package:app/core/networking/api_response_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'food_category_api.g.dart';

@RestApi()
@lazySingleton
abstract class FoodCategoryApi {
  @factoryMethod
  factory FoodCategoryApi(Dio dio) = _FoodCategoryApi;

  @GET('/food-categories')
  Future<DataApiResponse> getFoodCategories();

  @POST('/food-categories')
  Future<VoidApiResponse> createFoodCategory(
    @Body() Map<String, dynamic> body,
  );

  @PATCH('/food-categories/{name}')
  Future<VoidApiResponse> updateFoodCategory(
    @Path('name') String name,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/food-categories/{name}')
  Future<VoidApiResponse> deleteFoodCategory(
    @Path('name') String name,
  );
}
