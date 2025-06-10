import 'package:app/core/networking/api_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:injectable/injectable.dart';

part 'restaurant_api.g.dart';

@RestApi()
@lazySingleton
abstract class RestaurantApi {
  @factoryMethod
  factory RestaurantApi(Dio dio) = _RestaurantApi;

  @GET('/restaurants')
  Future<MultiDataApiResponse> getRestaurants(
    @Queries() Map<String, dynamic> queries,
  );

  @GET('/restaurants/{id}')
  Future<DataApiResponse> getRestaurantById(@Path('id') String id);

  @POST('/restaurants')
  Future<DataApiResponse> createRestaurant(
    @Body() Map<String, dynamic> body,
  );

  @PATCH('/restaurants/{id}')
  Future<DataApiResponse> updateRestaurant(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/restaurants/{id}')
  Future<DataApiResponse> deleteRestaurant(@Path('id') String id);
}
