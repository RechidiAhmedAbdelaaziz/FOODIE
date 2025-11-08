import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/list_extenstion.dart';
import 'package:app/core/shared/types/cubit_error_state.dart';
import 'package:app/features/restaurant/data/dto/restaurant_filter_dto.dart';
import 'package:app/features/restaurant/data/model/restaurant_model.dart';
import 'package:app/features/restaurant/data/repository/restaurant_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'restaurants_state.dart';

class RestaurantsCubit extends Cubit<RestaurantsState> {
  final _repo = locator<RestaurantRepo>();

  RestaurantsCubit({required RestaurantFilterDTO filter})
    : _filter = filter,
      super(RestaurantsState.initial());

  final RestaurantFilterDTO _filter;
  RestaurantFilterDTO get filter => _filter;

  List<RestaurantModel> get restaurants => state._restaurants;

  void refresh() {
    _filter.firstPage();
    emit(RestaurantsState.initial());
    fetchRestaurants();
  }

  void fetchRestaurants() async {
    if (state.isLoading) return;

    emit(state._loading());

    final result = await _repo.getRestaurants(_filter);

    result.when(
      success: (result) {
        final restaurants = result.data;

        if (restaurants.isNotEmpty) _filter.nextPage();

        emit(state._loaded(restaurants));
      },
      error: (error) => emit(state._error(error.message)),
    );
  }
}
