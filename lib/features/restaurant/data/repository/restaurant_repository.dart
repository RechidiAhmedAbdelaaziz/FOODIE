import 'package:app/core/di/locator.dart';
import 'package:app/core/networking/network_repository.dart';
import 'package:app/core/shared/models/pagination_result.dart';
import 'package:app/features/restaurant/data/dto/restaurant_dto.dart';
import 'package:app/features/restaurant/data/dto/restaurant_filter_dto.dart';
import 'package:app/features/restaurant/data/model/restaurant_model.dart';
import 'package:injectable/injectable.dart';

import '../source/restaurant_api.dart';

@lazySingleton
class RestaurantRepo extends NetworkRepository {
  final _restaurantApi = locator<RestaurantApi>();

  RepoListResult<RestaurantModel> getRestaurants(
    RestaurantFilterDto dto,
  ) {
    return tryApiCall(
      apiCall: () async => _restaurantApi.getRestaurants(dto.toMap()),
      onResult: (response) => PaginationResult.fromResponse(
        response: response,
        fromJson: RestaurantModel.fromJson,
      ),
    );
  }

  RepoResult<RestaurantModel> getRestaurant(String id) {
    return tryApiCall(
      apiCall: () async => _restaurantApi.getRestaurantById(id),
      onResult: (response) => RestaurantModel.fromJson(response.data),
    );
  }

  RepoResult<RestaurantModel> createRestaurant(RestaurantDto dto) {
    return tryApiCall(
      apiCall: () async =>
          _restaurantApi.createRestaurant(await dto.toMap()),
      onResult: (response) => RestaurantModel.fromJson(response.data),
    );
  }

  RepoResult<RestaurantModel> updateRestaurant(RestaurantDto dto) {
    return tryApiCall(
      apiCall: () async =>
          _restaurantApi.updateRestaurant(dto.id, await dto.toMap()),
      onResult: (response) => RestaurantModel.fromJson(response.data),
    );
  }

  RepoResult<void> deleteRestaurant(String id) {
    return tryApiCall(
      apiCall: () async => _restaurantApi.deleteRestaurant(id),
      onResult: (response) {},
    );
  }
}
