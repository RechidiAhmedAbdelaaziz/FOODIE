// ignore_for_file: library_private_types_in_public_api

part of 'restaurants_cubit.dart';

enum _RestaurantStatus { initial, loading, loaded, error }

class RestaurantsState with CubitErrorHandling {
  final List<RestaurantModel> _restaurants;
  final _RestaurantStatus _status;
  final String? _errorMessage;

  RestaurantsState({
    List<RestaurantModel> restaurants = const [],
    _RestaurantStatus status = _RestaurantStatus.initial,
    String? errorMessage,
  }) : _restaurants = restaurants,
       _status = status,
       _errorMessage = errorMessage;

  factory RestaurantsState.initial() => RestaurantsState();

  @override
  String? get error => _errorMessage;
  bool get isLoading => _status == _RestaurantStatus.loading;

  // Copy with method
  RestaurantsState _copyWith({
    List<RestaurantModel>? restaurants,
    _RestaurantStatus? status,
    String? errorMessage,
  }) {
    return RestaurantsState(
      restaurants: restaurants ?? _restaurants,
      status: status ?? _status,
      errorMessage: errorMessage,
    );
  }

  RestaurantsState _loading() =>
      _copyWith(status: _RestaurantStatus.loading);

  RestaurantsState _loaded(List<RestaurantModel> restaurants) {
    return _copyWith(
      restaurants: _restaurants.withAllUnique(restaurants),
      status: _RestaurantStatus.loaded,
    );
  }

  RestaurantsState _error(String message) {
    return _copyWith(
      status: _RestaurantStatus.error,
      errorMessage: message,
    );
  }
}
