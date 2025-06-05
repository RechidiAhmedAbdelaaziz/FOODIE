// ignore_for_file: library_private_types_in_public_api

part of 'food_form_cubit.dart';

enum _FoodFormStatus { initial, loading, loaded, success, error }

class FoodFormState<TDto> with CubitErrorHandling {
  final TDto? _dto;
  final _FoodFormStatus _status;
  final String? _errorMessage;

  FoodFormState({
    TDto? dto,
    _FoodFormStatus status = _FoodFormStatus.initial,
    String? errorMessage,
  }) : _dto = dto,
       _status = status,
       _errorMessage = errorMessage;

  bool get isLoading => _status == _FoodFormStatus.loading;
  bool get isLoaded => _dto != null;

  @override
  String? get error => _errorMessage;

  factory FoodFormState.initial() => FoodFormState();

  FoodFormState<TDto> _copyWith({
    TDto? dto,
    _FoodFormStatus? status,
    String? errorMessage,
  }) {
    return FoodFormState<TDto>(
      dto: dto ?? _dto,
      status: status ?? _status,
      errorMessage: errorMessage,
    );
  }

  FoodFormState<TDto> _loading() {
    return _copyWith(status: _FoodFormStatus.loading);
  }

  FoodFormState<TDto> _loaded(TDto dto) {
    return _copyWith(dto: dto, status: _FoodFormStatus.loaded);
  }

  FoodFormState<TDto> _success(FoodModel food) {
    return _SuccessState(food, this._dto);
  }

  FoodFormState<TDto> _error(String message) {
    return _copyWith(
      status: _FoodFormStatus.error,
      errorMessage: message,
    );
  }

  void onSuccess(ValueChanged<FoodModel> onSuccess) {}
}

class _SuccessState<TDto> extends FoodFormState<TDto> {
  final FoodModel food;

  _SuccessState(this.food, TDto? dto)
    : super(dto: dto, status: _FoodFormStatus.success);

  @override
  void onSuccess(ValueChanged<FoodModel> onSuccess) {
    onSuccess(food);
  }
}
