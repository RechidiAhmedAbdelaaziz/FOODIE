// ignore_for_file: library_private_types_in_public_api

part of 'staff_form_cubit.dart';

enum _StaffFormStatus { initial, loading, loaded, success, error }

class StaffFormState<TDto extends FormDTO> with CubitErrorHandling {
  final TDto? _dto;
  final _StaffFormStatus _status;
  final String? _errorMessage;

  StaffFormState({
    TDto? dto,
    _StaffFormStatus status = _StaffFormStatus.initial,
    String? errorMessage,
  }) : _dto = dto,
       _status = status,
       _errorMessage = errorMessage;

  bool get isLoading => _status == _StaffFormStatus.loading;
  bool get isLoaded => _dto != null;

  @override
  String? get error => _errorMessage;

  factory StaffFormState.initial() => StaffFormState();

  StaffFormState<TDto> _copyWith({
    TDto? dto,
    _StaffFormStatus? status,
    String? errorMessage,
  }) {
    return StaffFormState<TDto>(
      dto: dto ?? _dto,
      status: status ?? _status,
      errorMessage: errorMessage,
    );
  }

  StaffFormState<TDto> _loading() {
    return _copyWith(status: _StaffFormStatus.loading);
  }

  StaffFormState<TDto> _loaded(TDto dto) {
    return _copyWith(dto: dto, status: _StaffFormStatus.loaded);
  }

  StaffFormState<TDto> _success(StaffModel staff) {
    return _SuccessState(staff, this._dto);
  }

  StaffFormState<TDto> _error(String message) {
    return _copyWith(
      status: _StaffFormStatus.error,
      errorMessage: message,
    );
  }

  void onSuccess(ValueChanged<StaffModel> onSuccess) {}
}

class _SuccessState<TDto extends FormDTO>
    extends StaffFormState<TDto> {
  final StaffModel staff;

  _SuccessState(this.staff, TDto? dto)
    : super(dto: dto, status: _StaffFormStatus.success);

  @override
  void onSuccess(ValueChanged<StaffModel> onSuccess) {
    onSuccess(staff);
  }
}
