import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'client_router.dart';
part 'server_router.dart';
part 'owner_router.dart';

abstract class AppRouter {
  String get initialRoute;

  List<RouteBase> get routes;

  FutureOr<String?> handelRedirect(
    BuildContext context,
    GoRouterState state,
  );

  GoRouter get router => GoRouter(
    initialLocation: initialRoute,
    routes: routes,
    debugLogDiagnostics:
        kDebugMode, // Enable debug logging in development mode
    redirect: handelRedirect,
  );
}
