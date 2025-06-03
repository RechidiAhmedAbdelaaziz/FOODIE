import 'package:app/core/di/locator.dart';
import 'package:app/core/shared/types/cubit_error_state.dart';
import 'package:app/features/auth/data/dto/verify_code_dto.dart';
import 'package:app/features/auth/data/repository/auth_repository.dart';
import 'package:app/features/auth/logic/auth_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'verify_code_state.dart';

class VerifyCodeCubit extends Cubit<VerifyCodeState> {
  final _authRepo = locator<AuthRepo>();

  VerifyCodeCubit(String login)
    : super(VerifyCodeState.initial(VerifyCodeDTO(login: login)));

  VerifyCodeDTO get dto => state._dto;

  void verifyCode() async {
    if (state.isLoading || !dto.isValid) return;

    emit(state._loading());

    final result = await _authRepo.verifyCode(dto);

    result.when(
      success: (tokens) async {
        await locator<AuthCubit>().authenticate(tokens);
        emit(state._success());
      },
      error: (error) => emit(state._failure(error.message)),
    );
  }
}
