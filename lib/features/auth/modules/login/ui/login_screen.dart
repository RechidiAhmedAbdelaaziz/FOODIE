import 'package:app/core/extensions/snackbar.extension.dart';
import 'package:app/core/flavors/flavors.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/shared/widgets/app_loading_widget.dart';
import 'package:app/core/shared/widgets/app_text_field.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/auth/modules/login/logic/login_cubit.dart';
import 'package:app/features/auth/modules/verifycode/ui/verify_code_screen.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

part 'widget/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (LoginCubit cubit) => cubit.state.isLoading,
    );

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        state.onError(context.showErrorSnackbar);
        state.onSuccess(
          (login) => context.to(
            AppRoutes.verifyCode,
            VerifyCodeParams(login: login),
          ),
        );
      },
      child: Scaffold(
        body: isLoading
            ? const AppLoadingWidget()
            : const _LoginForm(),
      ),
    );
  }
}
