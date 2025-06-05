import 'package:app/core/di/locator.dart';
import 'package:app/core/networking/network_repository.dart';
import 'package:app/core/shared/models/pagination_result.dart';
import 'package:app/features/food/data/dto/food_dto.dart';
import 'package:app/features/food/data/dto/food_filter_dto.dart';
import 'package:app/features/food/data/model/food_model.dart';
import 'package:injectable/injectable.dart';

import '../source/food_api.dart';

@lazySingleton
class FoodRepo extends NetworkRepository {
  final _foodApi = locator<FoodApi>();

  RepoListResult<FoodModel> getFoods(FoodFilterDTO filter) {
    return tryApiCall(
      apiCall: () async => _foodApi.getFoods(filter.toMap()),
      onResult: (response) => PaginationResult.fromResponse(
        response: response,
        fromJson: FoodModel.fromJson,
      ),
    );
  }

  RepoResult<FoodModel> getFood(String id) {
    return tryApiCall(
      apiCall: () async => _foodApi.getFoodById(id),
      onResult: (response) => FoodModel.fromJson(response.data),
    );
  }

  RepoResult<FoodModel> createFood(FoodDTO dto) {
    return tryApiCall(
      apiCall: () async => _foodApi.createFood(await dto.toMap()),
      onResult: (response) => FoodModel.fromJson(response.data),
    );
  }

  RepoResult<FoodModel> updateFood(FoodDTO dto) {
    return tryApiCall(
      apiCall: () async =>
          _foodApi.updateFood(dto.id, await dto.toMap()),
      onResult: (response) => FoodModel.fromJson(response.data),
    );
  }

  RepoResult<void> deleteFood(String id) {
    return tryApiCall(
      apiCall: () async => _foodApi.deleteFood(id),
      onResult: (response) {},
    );
  }
}
