// ignore_for_file: library_private_types_in_public_api

part of 'login_cubit.dart';

enum _LoginStatus { initial, loading, success, failure }

class LoginState with CubitErrorHandling {
  final LoginDTO _dto;
  final String? _error;
  final _LoginStatus _status;

  LoginState({
    required LoginDTO dto,
    String? error,
    _LoginStatus status = _LoginStatus.initial,
  }) : _error = error,
       _status = status,
       _dto = dto;

  factory LoginState.initial() => LoginState(dto: LoginDTO());

  @override
  String? get error => _error;

  bool get isLoading => _status == _LoginStatus.loading;

  LoginState _copyWith({String? error, _LoginStatus? status}) {
    return LoginState(
      dto: _dto,
      error: error,
      status: status ?? _status,
    );
  }

  LoginState _loading() => _copyWith(status: _LoginStatus.loading);

  LoginState _success() => _copyWith(status: _LoginStatus.success);

  LoginState _failure(String error) {
    return _copyWith(error: error, status: _LoginStatus.failure);
  }

  void onSuccess(ValueChanged<String> callback) {
    if (_status == _LoginStatus.success) {
      callback(_dto.login);
    }
  }
}
