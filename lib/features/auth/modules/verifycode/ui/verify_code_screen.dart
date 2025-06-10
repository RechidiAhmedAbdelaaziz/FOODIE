import 'package:app/core/extensions/snackbar.extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/shared/widgets/app_loading_widget.dart';
import 'package:app/core/shared/widgets/app_text_field.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/features/auth/modules/verifycode/logic/verify_code_cubit.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

part 'widget/verify_code_form.dart';

class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (VerifyCodeCubit cubit) => cubit.state.isLoading,
    );

    return BlocListener<VerifyCodeCubit, VerifyCodeState>(
      listener: (context, state) {
        state.onError(context.showErrorSnackbar);
        state.onSuccess(() => context.to(AppRoutes.home, null));
      },
      child: Scaffold(
        body: isLoading
            ? const AppLoadingWidget()
            : const _VerifyCodeForm(),
      ),
    );
  }
}
