// ignore_for_file: library_private_types_in_public_api

part of 'table_form_cubit.dart';

enum _TableFormStatus { initial, loading, loaded, success, error }

class TableFormState<TDto extends FormDTO> with CubitErrorHandling {
  final TDto? _dto;
  final _TableFormStatus _status;
  final String? _errorMessage;

  TableFormState({
    TDto? dto,
    _TableFormStatus status = _TableFormStatus.initial,
    String? errorMessage,
  }) : _dto = dto,
       _status = status,
       _errorMessage = errorMessage;

  bool get isLoading => _status == _TableFormStatus.loading;
  bool get isLoaded => _dto != null;

  @override
  String? get error => _errorMessage;

  factory TableFormState.initial() => TableFormState();

  TableFormState<TDto> _copyWith({
    TDto? dto,
    _TableFormStatus? status,
    String? errorMessage,
  }) {
    return TableFormState<TDto>(
      dto: dto ?? _dto,
      status: status ?? _status,
      errorMessage: errorMessage,
    );
  }

  TableFormState<TDto> _loading() {
    return _copyWith(status: _TableFormStatus.loading);
  }

  TableFormState<TDto> _loaded(TDto dto) {
    return _copyWith(dto: dto, status: _TableFormStatus.loaded);
  }

  TableFormState<TDto> _success(TableModel table) {
    return _SuccessState(table, _dto);
  }

  TableFormState<TDto> _error(String message) {
    return _copyWith(
      status: _TableFormStatus.error,
      errorMessage: message,
    );
  }

  void onSuccess(ValueChanged<TableModel> onSuccess) {}
}

class _SuccessState<TDto extends FormDTO>
    extends TableFormState<TDto> {
  final TableModel table;

  _SuccessState(this.table, TDto? dto)
    : super(dto: dto, status: _TableFormStatus.success);

  @override
  void onSuccess(ValueChanged<TableModel> onSuccess) {
    onSuccess(table);
  }
}
