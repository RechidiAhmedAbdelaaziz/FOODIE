import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/shared/widgets/app_text_field.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class StaffFormView extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController loginController;

  final VoidCallback onSave;

  final bool isLoading;

  final GlobalKey<FormState> formKey;

  const StaffFormView({
    super.key,
    required this.nameController,
    required this.loginController,
    required this.onSave,
    required this.isLoading,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: isLoading
          ? SizedBox(
              height: 4.h,
              child: LinearProgressIndicator(color: AppColors.green),
            )
          : Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Symbols.person_apron_rounded),
                  heightSpace(16),

                  AppTextField(
                    controller: nameController,
                    label: 'Name',
                    hintText: 'Enter staff name',
                    prefixIcon: Symbols.person,
                    keyboardType: TextInputType.name,
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  heightSpace(12),

                  AppTextField(
                    controller: loginController,
                    label: 'Contact',
                    hintText: 'Enter staff Email or Phone',
                    prefixIcon: Symbols.login,
                    keyboardType: TextInputType.text,
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Contact is required';
                      }
                      if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value) &&
                          !RegExp(r'^\d{10}$').hasMatch(value)) {
                        return 'Enter a valid email or phone number';
                      }
                      return null;
                    },
                  ),

                  heightSpace(16),

                  Row(
                    spacing: 16.w,
                    children: [
                      AppButton.secondary(
                        text: 'Cancel',
                        onPressed: () => context.back(),
                      ),

                      AppButton.primary(
                        text: 'Save',
                        onPressed: onSave,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
