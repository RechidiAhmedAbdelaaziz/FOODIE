import 'package:app/core/di/locator.dart';
import 'package:app/core/routing/routers/router.dart';
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

  Future<void> authenticate(AuthTokens tokens) async {
    await _authCache.saveTokens(tokens);
    emit(state._authenticated());
  }

  Future<void> refreshToken() async {
    final refreshToken = await _authCache.refreshToken;
    if (refreshToken == null) {
      emit(state._unauthenticated());
      return;
    }

    final result = await _authRepo.refreshToken(refreshToken);
    result.when(
      success: (tokens) => authenticate(tokens),
      error: (_) => logOut(),
    );
  }

  Future<void> logOut() async {
    _authCache.logOut();
    locator<AppRouter>().router.go('/login');
    emit(state._unauthenticated());
  }
}
