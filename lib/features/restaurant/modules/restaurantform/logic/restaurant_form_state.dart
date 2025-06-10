// ignore_for_file: library_private_types_in_public_api

part of 'restaurant_form_cubit.dart';

enum _RestaurantFormStatus { initial, loading, loaded, success, error }

class RestaurantFormState<TDto> with CubitErrorHandling {
  final TDto? _dto;
  final _RestaurantFormStatus _status;
  final String? _errorMessage;

  RestaurantFormState({
    TDto? dto,
    _RestaurantFormStatus status = _RestaurantFormStatus.initial,
    String? errorMessage,
  })  : _dto = dto,
        _status = status,
        _errorMessage = errorMessage;

  bool get isLoading => _status == _RestaurantFormStatus.loading;
  bool get isLoaded => _dto != null;

  @override
  String? get error => _errorMessage;

  factory RestaurantFormState.initial() => RestaurantFormState();

  RestaurantFormState<TDto> _copyWith({
    TDto? dto,
    _RestaurantFormStatus? status,
    String? errorMessage,
  }) {
    return RestaurantFormState<TDto>(
      dto: dto ?? _dto,
      status: status ?? _status,
      errorMessage: errorMessage,
    );
  }

  RestaurantFormState<TDto> _loading() {
    return _copyWith(status: _RestaurantFormStatus.loading);
  }

  RestaurantFormState<TDto> _loaded(TDto dto) {
    return _copyWith(dto: dto, status: _RestaurantFormStatus.loaded);
  }

  RestaurantFormState<TDto> _success(RestaurantModel restaurant) {
    return _SuccessState(restaurant, this._dto);
  }

  RestaurantFormState<TDto> _error(String message) {
    return _copyWith(
      status: _RestaurantFormStatus.error,
      errorMessage: message,
    );
  }

  void onSuccess(ValueChanged<RestaurantModel> onSuccess) {}
}

class _SuccessState<TDto> extends RestaurantFormState<TDto> {
  final RestaurantModel restaurant;

  _SuccessState(this.restaurant, TDto? dto)
      : super(dto: dto, status: _RestaurantFormStatus.success);

  @override
  void onSuccess(ValueChanged<RestaurantModel> onSuccess) {
    onSuccess(restaurant);
  }
}
