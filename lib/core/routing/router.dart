import 'dart:async';

import 'package:app/core/di/locator.dart';
import 'package:app/features/auth/configs/auth_routes.dart';
import 'package:app/features/auth/logic/auth_cubit.dart';
import 'package:app/features/auth/modules/verifycode/ui/verify_code_screen.dart';
import 'package:app/features/food/modules/foodform/ui/food_form_screen.dart';
import 'package:app/features/food/modules/foodlist/ui/client_food_menu_screen.dart';
import 'package:app/features/food/modules/foodlist/ui/food_menu_screen.dart';
import 'package:app/features/history/modules/histories/ui/history_screen.dart';
import 'package:app/features/home/configs/home_routes.dart';
import 'package:app/features/order/modules/orders/orders_screen.dart';
import 'package:app/features/restaurant/modules/restaurantform/ui/restaurant_form_screen.dart';
import 'package:app/features/restaurant/modules/restaurants/ui/restaurants_screen.dart';
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
    initialLocation: AppRoutes.home.path,
    routes: [
      ...AuthRoutes.routes,
      ...HomeRoutes.routes,
      HistoryScreen.route,
      StaffsScreen.route,
      TablesScreen.route,
      ...FoodFormScreen.routes,
      FoodMenuScreen.route,
      RestaurantFormScreen.route,
      OrdersScreen.route,
      RestaurantsScreen.route,
      TableFoodMenuScreen.route,
    ],
    debugLogDiagnostics: true,

    redirect: _handelRedirect,
  );

  static FutureOr<String?> _handelRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final route = AppRoutes.values.firstWhere(
      (route) => route.path == state.uri.path,
      orElse: () => AppRoutes.home,
    );

    if (!route.isGuarded || locator<AuthCubit>().isAuthenticated) {
      return null;
    }

    return AppRoutes.login.path;
  }
}
