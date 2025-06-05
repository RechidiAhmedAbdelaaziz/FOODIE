import 'package:app/core/routing/router.dart';
import 'package:app/features/home/ui/home_screen.dart';
import 'package:go_router/go_router.dart';

abstract class HomeRoutes {
  static List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.home.path,
      builder: (context, state) => HomeScreen(),
    ),
  ];
}
