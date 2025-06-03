part of 'router.dart';

class ServerRouter extends AppRouter {
  @override
  String get initialRoute => '/';

  ServerRouter() : super([AppRoutes.login]);

  @override
  FutureOr<String?> handelRedirect(
    BuildContext context,
    GoRouterState state,
  ) {
    return null;
  }
}
