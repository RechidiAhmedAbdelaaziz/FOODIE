import 'package:app/core/di/locator.dart';
import 'package:app/core/networking/network_repository.dart';
import 'package:app/features/food/data/model/food_category_model.dart';
import 'package:injectable/injectable.dart';

import '../source/food_category_api.dart';

@lazySingleton
class FoodCategoryRepository extends NetworkRepository {
  final _foodCategoryApi = locator<FoodCategoryApi>();

  RepoResult<FoodCategoryModel> getFoodCategories() {
    return tryApiCall(
      apiCall: () async => await _foodCategoryApi.getFoodCategories(),
      onResult: (response) =>
          FoodCategoryModel.fromJson(response.data),
    );
  }

  RepoResult<void> createFoodCategory(String name) {
    return tryApiCall(
      apiCall: () async =>
          await _foodCategoryApi.createFoodCategory({'name': name}),
      onResult: (_) {},
    );
  }

  RepoResult<void> updateFoodCategory(String name, String newName) {
    return tryApiCall(
      apiCall: () async => _foodCategoryApi.updateFoodCategory(name, {
        'name': newName,
      }),
      onResult: (_) {},
    );
  }

  RepoResult<void> deleteFoodCategory(String name) {
    return tryApiCall(
      apiCall: () async => _foodCategoryApi.deleteFoodCategory(name),
      onResult: (_) {},
    );
  }
}
