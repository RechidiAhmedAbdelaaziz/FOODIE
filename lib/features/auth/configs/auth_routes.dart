import 'package:app/core/router/router.dart';
import 'package:app/features/auth/modules/login/logic/login_cubit.dart';
import 'package:app/features/auth/modules/login/ui/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class AuthRoutes {
  static List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.login.path,
      builder: (context, state) {
        return BlocProvider(
          create: (_) => LoginCubit(),
          child: LoginScreen(),
        ); // Replace with actual Home screen widget
      },
    ),
  ];
}
