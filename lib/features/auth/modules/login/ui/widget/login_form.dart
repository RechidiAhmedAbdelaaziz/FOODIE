part of '../login_screen.dart';

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final dto = context.read<LoginCubit>().dto;
    return Form(
      key: dto.formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            heightSpace(100),
            Assets.logo.logo.image(
              width: 190.w,
              height: 235.h,
              fit: BoxFit.cover,
            ),

            SvgPicture.asset(
              Assets.svg.logoTitle,
              height: 32.h,
              fit: BoxFit.cover,
            ),
            heightSpace(32),

            if (F.appFlavor != Flavor.client) AuthActionButtons(),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 32.h,
              ),
              child: ValueListenableBuilder(
                valueListenable: dto.loginWithEmailController,
                builder: (context, isEmail, child) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    child: Column(
                      children: [
                        if (F.appFlavor == Flavor.client)
                          AppTextField(
                            controller: dto.nameController,
                            label: 'Name',
                            hintText: 'Enter your name',
                            prefixIcon: Symbols.person,
                            isRequired: true,
                            validator: (name) {
                              if (name == null || name.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),

                        isEmail
                            ? AppTextField(
                                controller: dto.emailController,
                                label: 'Email',
                                hintText: 'Enter your email',
                                keyboardType:
                                    TextInputType.emailAddress,
                                prefixIcon: Symbols.email,
                                isRequired: true,
                                validator: (email) {
                                  if (email == null ||
                                      email.isEmpty) {
                                    return 'Email is required';
                                  }
                                  final emailRegex = RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                  );
                                  if (!emailRegex.hasMatch(email)) {
                                    return 'Invalid email format';
                                  }
                                  return null;
                                },
                              )
                            : AppTextField(
                                controller: dto.phoneController,
                                label: 'Phone',
                                hintText: 'Enter your phone number',
                                prefixIcon: Symbols.phone,
                                keyboardType: TextInputType.phone,
                                isRequired: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly,
                                  LengthLimitingTextInputFormatter(
                                    10,
                                  ),
                                ],
                                validator: (phone) {
                                  if (phone == null ||
                                      phone.isEmpty) {
                                    return 'Phone number is required';
                                  }
                                  if (phone.length != 10) {
                                    return 'Phone number must be 10 digits';
                                  }
                                  return null;
                                },
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),

            heightSpace(64),
            AppButton.primary(
              text: 'Continue',
              textColor: Colors.white,
              onPressed: context.read<LoginCubit>().login,
            ),
            heightSpace(16),
          ],
        ),
      ),
    );
  }
}

class AuthActionButtons extends StatelessWidget {
  const AuthActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final loginEmailController = context
        .read<LoginCubit>()
        .dto
        .loginWithEmailController;
    return ValueListenableBuilder(
      valueListenable: loginEmailController,
      builder: (context, isEmail, child) {
        return Container(
          width: 300.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.r),
            border: Border.all(
              color: AppColors.greenLight,
              width: 2.w,
            ),
          ),
          child: Row(
            children: [
              _buildActionButton(
                'With Email',
                selected: isEmail,
                onTap: () => loginEmailController.setValue(true),
              ),
              _buildActionButton(
                'With Phone',
                selected: !isEmail,
                onTap: () => loginEmailController.setValue(false),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    String text, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(40.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.greenLight
                : Colors.transparent,
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Center(
            child: Text(
              text,
              style: AppTextStyles.normal.copyWith(
                color: selected ? Colors.white : AppColors.green,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
