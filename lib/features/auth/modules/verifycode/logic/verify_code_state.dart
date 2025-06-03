// ignore_for_file: library_private_types_in_public_api

part of 'verify_code_cubit.dart';

enum _VerifyCodeStatus { initial, loading, success, failure }

class VerifyCodeState with CubitErrorHandling {
  final VerifyCodeDTO _dto;
  final String? _error;
  final _VerifyCodeStatus _status;

  VerifyCodeState({
    required VerifyCodeDTO dto,
    String? error,
    _VerifyCodeStatus status = _VerifyCodeStatus.initial,
  }) : _dto = dto,
       _error = error,
       _status = status;

  factory VerifyCodeState.initial(VerifyCodeDTO dto) =>
      VerifyCodeState(dto: dto);

  @override
  String? get error => _error;

  bool get isLoading => _status == _VerifyCodeStatus.loading;

  VerifyCodeState _copyWith({
    String? error,
    _VerifyCodeStatus? status,
  }) {
    return VerifyCodeState(
      dto: _dto,
      error: error ?? _error,
      status: status ?? _status,
    );
  }

  VerifyCodeState _loading() =>
      _copyWith(status: _VerifyCodeStatus.loading);

  VerifyCodeState _success() =>
      _copyWith(status: _VerifyCodeStatus.success);

  VerifyCodeState _failure(String error) {
    return _copyWith(error: error, status: _VerifyCodeStatus.failure);
  }

  void onSuccess(VoidCallback callback) {
    if (_status == _VerifyCodeStatus.success) {
      callback();
    }
  }
}
