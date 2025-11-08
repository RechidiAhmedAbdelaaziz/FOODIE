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

  @GET('/restaurants/me')
  Future<DataApiResponse> getMyRestaurant();

  @GET('/restaurants/{id}')
  Future<DataApiResponse> getRestaurantById(
    @Path('id') String id,
  );

  @PATCH('/restaurants')
  Future<DataApiResponse> updateRestaurant(
    @Body() Map<String, dynamic> body,
  );
}
