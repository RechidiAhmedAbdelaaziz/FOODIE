part of '../verify_code_screen.dart';

class _VerifyCodeForm extends StatelessWidget {
  const _VerifyCodeForm();

  @override
  Widget build(BuildContext context) {
    final dto = context.read<VerifyCodeCubit>().dto;
    return Form(
      key: dto.formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            heightSpace(100),
            SvgPicture.asset(
              Assets.svg.logo,
              width: 190.w,
              height: 235.h,
            ),
            heightSpace(32),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 32.h,
              ),
              child: AppTextField(
                controller: dto.codeController,
                label: 'Verification Code',
                hintText:
                    '${'Enter the code sent to'.tr(context)}${dto.login}',
                keyboardType: TextInputType.number,
                prefixIcon: Symbols.lock,
                isRequired: true,
                validator: (code) {
                  if (code == null || code.isEmpty) {
                    return 'Code is required';
                  }
                  // Add more validation if needed
                  return null;
                },
              ),
            ),

            heightSpace(64),
            AppButton.primary(
              text: 'Continue',
              textColor: Colors.white,
              onPressed: context.read<VerifyCodeCubit>().verifyCode,
            ),
            heightSpace(16),
          ],
        ),
      ),
    );
  }
}
