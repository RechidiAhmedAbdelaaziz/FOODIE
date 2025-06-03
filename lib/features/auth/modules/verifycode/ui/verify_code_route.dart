import 'package:app/core/routing/app_route.dart';
import 'package:app/features/auth/modules/verifycode/logic/verify_code_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'verify_code_screen.dart';

@lazySingleton
class VerifyCodeRoute extends AppRoute<String> with RouteArgs {
  VerifyCodeRoute()
    : super(
        '/verify-code',
        builder: (context, state) => BlocProvider(
          create: (context) => VerifyCodeCubit(state.uri.queryParameters['login'] ?? ''),
          child: const VerifyCodeScreen(),
        ),
      );

  @override
  Map<String, String> toPathParams(_) => {};

  @override
  Map<String, String> toQueryParams(String login) => {'login': login};
}

