import 'package:app/core/routing/app_route.dart';
import 'package:app/features/auth/modules/login/logic/login_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'login_screen.dart';

@lazySingleton
class LoginRoute extends AppRoute<Null> with NoArgsRoute {
  LoginRoute()
    : super(
        '/login',
        builder: (context, state) => BlocProvider(
          create: (context) => LoginCubit(),
          child: const LoginScreen(),
        ),
      );
}
