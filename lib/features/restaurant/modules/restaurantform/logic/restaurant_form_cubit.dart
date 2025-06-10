import 'package:app/core/di/locator.dart';
import 'package:app/core/shared/types/cubit_error_state.dart';
import 'package:app/features/restaurant/data/dto/restaurant_dto.dart';
import 'package:app/features/restaurant/data/model/restaurant_model.dart';
import 'package:app/features/restaurant/data/repository/restaurant_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'restaurant_form_state.dart';

class RestaurantFormCubit
    extends Cubit<RestaurantFormState<RestaurantDTO>> {
  final _repo = locator<RestaurantRepo>();
  RestaurantFormCubit() : super(RestaurantFormState.initial());

  RestaurantDTO get dto => state._dto!;

  void init() async {
    emit(state._loading());

    final result = await _repo.getRestaurant();
    result.when(
      success: (restaurant) =>
          emit(state._loaded(RestaurantDTO(restaurant))),
      error: (error) => emit(state._error(error.message)),
    );
  }

  void save() async {
    if (state.isLoading || !dto.isValid) return;

    emit(state._loading());

    final result = await _repo.updateRestaurant(dto);

    result.when(
      success: (restaurant) => emit(state._success(restaurant)),
      error: (error) => emit(state._error(error.message)),
    );
  }
}
