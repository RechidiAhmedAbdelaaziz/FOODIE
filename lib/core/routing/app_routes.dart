import 'package:app/core/di/locator.dart';
import 'package:app/features/auth/modules/login/ui/login_route.dart';

abstract class AppRoutes {
  static LoginRoute get login => locator<LoginRoute>();
}
