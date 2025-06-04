import 'dart:async';

import 'package:app/features/auth/configs/auth_routes.dart';
import 'package:app/features/history/history/ui/history_screen.dart';
import 'package:app/features/home/configs/home_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'app_route.dart';

part 'app_routes.dart';

@lazySingleton
class AppRouter {
  final router = GoRouter(
    initialLocation: '/students',
    routes: [
      ...AuthRoutes.routes,
      ...HomeRoutes.routes,
      HistoryScreen.route,
    ],
    debugLogDiagnostics: true,

    redirect: _handelRedirect,
  );

  static FutureOr<String?> _handelRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    return null;
  }
}
