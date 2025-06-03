import 'package:app/core/di/locator.dart';
import 'package:app/features/auth/modules/login/ui/login_route.dart';
import 'package:app/features/auth/modules/verifycode/ui/verify_code_route.dart';

abstract class AppRoutes {
  static LoginRoute get login => locator<LoginRoute>();

  static VerifyCodeRoute get verifyCode => locator<VerifyCodeRoute>();
}
