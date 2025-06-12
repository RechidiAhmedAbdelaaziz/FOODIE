import 'package:app/core/di/locator.dart';
import 'package:app/core/networking/network_repository.dart';
import 'package:app/core/services/geolocator/geo_locator_service.dart';
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
    RestaurantFilterDTO dto,
  ) {
    return tryApiCall(
      apiCall: () async => _restaurantApi.getRestaurants({
        ...dto.toMap(),
        ...(await locator<GeoLocatorService>().getCurrentLocation())
            .toMap(), // {latitude, longitude}
      }),
      onResult: (response) => PaginationResult.fromResponse(
        response: response,
        fromJson: RestaurantModel.fromJson,
      ),
    );
  }

  RepoResult<RestaurantModel> getRestaurant() {
    return tryApiCall(
      apiCall: () async => _restaurantApi.getRestaurantById(),
      onResult: (response) => RestaurantModel.fromJson(response.data),
    );
  }

  RepoResult<RestaurantModel> updateRestaurant(RestaurantDTO dto) {
    return tryApiCall(
      apiCall: () async =>
          _restaurantApi.updateRestaurant(await dto.toMap()),
      onResult: (response) => RestaurantModel.fromJson(response.data),
    );
  }
}
