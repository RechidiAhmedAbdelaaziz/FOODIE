import 'package:app/core/di/locator.dart';
import 'package:app/core/shared/types/cubit_error_state.dart';
import 'package:app/features/auth/data/dto/login_dto.dart';
import 'package:app/features/auth/data/repository/auth_repository.dart';
import 'package:app/features/auth/logic/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final _authRepo = locator<AuthRepo>();
  LoginCubit() : super(LoginState.initial());

  LoginDTO get dto => state._dto;

  void login() async {
    if (state.isLoading || !dto.isValid) return;

    emit(state._loading());

    final result = await _authRepo.login(dto);

    result.when(
      success: (tokens) async {
        await locator<AuthCubit>().authenticate(tokens);
        emit(state._success());
      },
      error: (error) => emit(state._failure(error.message)),
    );
  }

  @override
  Future<void> close() {
    dto.dispose();
    return super.close();
  }
}
