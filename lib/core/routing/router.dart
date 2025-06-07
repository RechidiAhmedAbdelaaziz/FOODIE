import 'dart:async';

import 'package:app/features/auth/configs/auth_routes.dart';
import 'package:app/features/food/modules/foodform/ui/food_form_screen.dart';
import 'package:app/features/food/modules/foodlist/ui/food_menu_screen.dart';
import 'package:app/features/history/modules/histories/ui/history_screen.dart';
import 'package:app/features/home/configs/home_routes.dart';
import 'package:app/features/staff/modules/staffs/ui/staffs_screen.dart';
import 'package:app/features/table/modules/tables/ui/tables_screen.dart';
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
      StaffsScreen.route,
      TablesScreen.route,
      ...FoodFormScreen.routes,
      FoodMenuScreen.route,
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
