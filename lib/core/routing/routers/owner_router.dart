part of 'router.dart';

class OwnerRouter extends AppRouter {
  @override
  String get initialRoute => '/';

  OwnerRouter() : super([AppRoutes.login]);

  @override
  FutureOr<String?> handelRedirect(
    BuildContext context,
    GoRouterState state,
  ) {
    if (!locator<AuthCubit>().isAuthenticated) {
      return AppRoutes.login.getPath();
    } else {
      return null;
    }
  }
}
