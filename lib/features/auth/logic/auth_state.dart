// ignore_for_file: library_private_types_in_public_api

part of 'auth_cubit.dart';

enum _AuthStatus { initial, authenticated, unauthenticated }

class AuthState {
  final _AuthStatus status;

  AuthState({this.status = _AuthStatus.initial});

  factory AuthState.initial() => AuthState();

  AuthState _copyWith({_AuthStatus? status}) =>
      AuthState(status: status ?? this.status);

  AuthState _authenticated() =>
      _copyWith(status: _AuthStatus.authenticated);

  AuthState _unauthenticated() =>
      _copyWith(status: _AuthStatus.unauthenticated);

      
}
