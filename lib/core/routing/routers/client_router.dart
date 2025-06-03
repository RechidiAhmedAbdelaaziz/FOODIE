part of 'router.dart';

class ClientRouter extends AppRouter {
  @override
  String get initialRoute => '/';

  ClientRouter() : super([AppRoutes.login]);

  @override
  FutureOr<String?> handelRedirect(
    BuildContext context,
    GoRouterState state,
  ) {
    // Implement any client-side redirection logic here
    // For example, redirect to login if not authenticated
    return null; // No redirection by default
  }
}
