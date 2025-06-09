import 'package:app/core/networking/api_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:injectable/injectable.dart';

part 'food_api.g.dart';

@RestApi()
@lazySingleton
abstract class FoodApi {
  @factoryMethod
  factory FoodApi(Dio dio) = _FoodApi;

  @GET('/foods')
  Future<MultiDataApiResponse> getFoods(
    @Queries() Map<String, dynamic> queries,
  );

  @GET('/foods/{id}')
  Future<DataApiResponse> getFoodById(@Path('id') String id);

  @POST('/foods')
  Future<DataApiResponse> createFood(
    @Body() Map<String, dynamic> body,
  );

  @PATCH('/foods/{id}')
  Future<DataApiResponse> updateFood(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/foods/{id}')
  Future<VoidApiResponse> deleteFood(@Path('id') String id);
}
