part of 'router.dart';

class OwnerRouter extends AppRouter {
  @override
  String get initialRoute => '/';

  @override
  List<RouteBase> get routes => [];

  @override
  FutureOr<String?> handelRedirect(
    BuildContext context,
    GoRouterState state,
  ) {
    // Implement any owner-side redirection logic here
    // For example, redirect to setup profile if not completed
    return null; // No redirection by default
  }
}
