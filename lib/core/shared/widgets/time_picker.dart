import 'package:app/core/extensions/date_formatter.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/shared/editioncontollers/generic_editingcontroller.dart';
import 'package:app/core/shared/widgets/form_field_props.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTimePicker extends StatefulWidget {
  final EditingController<TimeOfDay> controller;

  final String? label;
  final String? hintText;

  final bool isRequired;

  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffixWidget;

  final String? Function(TimeOfDay? time)? validator;

  const AppTimePicker({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.isRequired = false,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget,
    this.validator,
  });

  @override
  State<AppTimePicker> createState() => _AppTimePickerState();
}

class _AppTimePickerState extends State<AppTimePicker> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController(
      text: widget.controller.value?.toFormattedTime(),
    );

    widget.controller.addListener(() {
      _textEditingController.text =
          widget.controller.value?.toFormattedTime() ?? '';
    });

    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (_) =>
          widget.validator?.call(widget.controller.value),
      builder: (state) {
        return Column(
          spacing: 8.h,
          children: [
            if (widget.label != null)
              FormFieldLabel(
                widget.label!.tr(context),
                isRequired: widget.isRequired,
              ),

            TextField(
              controller: _textEditingController,
              readOnly: true,

              onTap: () async {
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime:
                      widget.controller.value ?? TimeOfDay.now(),
                );

                if (selectedTime != null) {
                  widget.controller.value = selectedTime;
                }
              },

              style: AppTextStyles.normal.copyWith(
                color: AppColors.white,
              ),

              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 16.h,
                ),

                isCollapsed: true,
                isDense: true,

                fillColor: AppColors.blue,
                filled: true,

                hintText: widget.hintText?.tr(context),
                hintStyle: AppTextStyles.normal.copyWith(
                  color: AppColors.grey,
                ),

                prefixIconConstraints: BoxConstraints(minWidth: 48.w),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: AppColors.white,
                        size: 30.r,
                      )
                    : null,
                suffixIcon: widget.suffixIcon != null
                    ? Icon(widget.suffixIcon, color: AppColors.white)
                    : widget.suffixWidget,

                error: state.hasError
                    ? FormFieldError(state.errorText!.tr(context))
                    : null,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: state.hasError
                      ? BorderSide(color: AppColors.red, width: 1.w)
                      : BorderSide.none,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
