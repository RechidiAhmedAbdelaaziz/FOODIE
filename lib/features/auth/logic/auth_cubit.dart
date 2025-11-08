import 'package:app/core/di/locator.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/features/auth/data/model/auth_tokens.dart';
import 'package:app/features/auth/data/repository/auth_repository.dart';
import 'package:app/features/auth/data/source/auth_cache.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;
  final AuthCache _authCache;

  AuthCubit(this._authRepo, this._authCache)
    : super(AuthState.initial());

  @postConstruct
  void init() => _authCache.accessToken != null
      ? emit(state._authenticated())
      : emit(state._unauthenticated());

  bool get isAuthenticated =>
      state.status == _AuthStatus.authenticated;

  Future<void> authenticate([AuthTokens? tokens]) async {
    if (tokens != null) await _authCache.saveTokens(tokens);
    emit(state._authenticated());
  }

  Future<bool> refreshToken() async {
    final refreshToken = await _authCache.refreshToken;
    if (refreshToken == null) {
      logOut();
      return false;
    }

    final result = await _authRepo.refreshToken(refreshToken);
    return result.when(
      success: (tokens) {
        authenticate(tokens);
        return true;
      },
      error: (_) {
        logOut();
        return false;
      },
    );
  }

  Future<void> logOut() async {
    _authCache.logOut();
    locator<AppRouter>().router.go('/login');
    emit(state._unauthenticated());
  }
}
