// ignore_for_file: library_private_types_in_public_api

part of 'food_list_cubit.dart';

enum _FoodListStatus { initial, loading, loaded, error }

class FoodListState with CubitErrorHandling {
  final List<FoodModel> _foods;
  final _FoodListStatus _status;
  final String? _errorMessage;

  FoodListState({
    List<FoodModel> foods = const [],
    _FoodListStatus status = _FoodListStatus.initial,
    String? errorMessage,
  }) : _foods = foods,
       _status = status,
       _errorMessage = errorMessage;

  factory FoodListState.initial() => FoodListState();

  @override
  String? get error => _errorMessage;
  bool get isLoading => _status == _FoodListStatus.loading;

  // Copy with method
  FoodListState _copyWith({
    List<FoodModel>? foods,
    _FoodListStatus? status,
    String? errorMessage,
  }) {
    return FoodListState(
      foods: foods ?? _foods,
      status: status ?? _status,
      errorMessage: errorMessage,
    );
  }

  FoodListState _loading() =>
      _copyWith(status: _FoodListStatus.loading);

  FoodListState _updating(FoodModel food) {
    return _UpdateingState(food, this);
  }

  FoodListState _loaded(List<FoodModel> foods) {
    return _copyWith(foods: foods, status: _FoodListStatus.loaded);
  }

  FoodListState _added(FoodModel food) {
    return _copyWith(
      foods: _foods.withUniqueFirst(food),
      status: _FoodListStatus.loaded,
    );
  }

  FoodListState _updated(FoodModel food) {
    return _copyWith(
      foods: _foods.withReplace(food),
      status: _FoodListStatus.loaded,
    );
  }

  FoodListState _deleted(FoodModel food) {
    return _copyWith(
      foods: _foods.without(food),
      status: _FoodListStatus.loaded,
    );
  }

  FoodListState _error(String message) {
    return _copyWith(
      status: _FoodListStatus.error,
      errorMessage: message,
    );
  }

  bool isUpdating(FoodModel food) => false;
}

class _UpdateingState extends FoodListState {
  final FoodModel _food;

  _UpdateingState(this._food, FoodListState state)
    : super(
        foods: state._foods,
        status: state._status,
        errorMessage: state.error,
      );

  @override
  bool isUpdating(FoodModel food) => food.id == _food.id;
}
