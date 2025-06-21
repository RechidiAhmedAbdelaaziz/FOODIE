import 'package:app/core/shared/editioncontollers/boolean_editigcontroller.dart';
import 'package:app/core/shared/widgets/form_field_props.dart';
import 'package:app/core/themes/font_styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppCheckBoxField extends StatelessWidget {
  final BooleanEditingController controller;

  final String? Function(bool?)? validator;

  final String label;
  final bool isRequired;

  const AppCheckBoxField({
    super.key,
    required this.controller,
    this.validator,
    required this.label,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (_) => validator?.call(controller.value),
      builder: (state) => Row(
        spacing: 4.w,
        children: [
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (_, value, __) {
              return Checkbox(
                value: value,
                onChanged: (value) {
                  controller.value = value ?? false;
                },
              );
            },
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: label,
                    style: AppTextStyles.medium,
                    children: [
                      if (isRequired)
                        TextSpan(
                          text: ' *',
                          style: AppTextStyles.medium.copyWith(
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),

                if (state.hasError) 
                  FormFieldError(state.errorText!),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
