part of 'router.dart';

class ServerRouter extends AppRouter {
  @override
  String get initialRoute => '/';

  @override
  List<RouteBase> get routes => [];

  @override
  FutureOr<String?> handelRedirect(
    BuildContext context,
    GoRouterState state,
  ) {
    return null;
  }
}
