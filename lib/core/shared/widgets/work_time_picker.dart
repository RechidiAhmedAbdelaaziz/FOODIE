import 'package:app/core/constants/data.dart';
import 'package:app/core/extensions/date_formatter.dart';
import 'package:app/core/extensions/popup_extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/shared/dto/working_time_dto.dart';
import 'package:app/core/shared/editioncontollers/list_generic_editingcontroller.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/shared/widgets/dropdown_field.dart';
import 'package:app/core/shared/widgets/form_field_props.dart';
import 'package:app/core/shared/widgets/time_picker.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class WorkTimeField extends StatelessWidget {
  final ListEditingController<WorkingTimeDto> controller;

  final String label;
  final String? hintText;

  final bool isRequired;

  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffixWidget;

  const WorkTimeField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.isRequired = true,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget,
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (_) => isRequired && controller.value.isEmpty
          ? 'At least one working time is required'.tr(context)
          : null,
      builder: (state) {
        return Column(
          spacing: 8.h,
          children: [
            Row(
              children: [
                Expanded(
                  child: FormFieldLabel(
                    label.tr(context),
                    isRequired: isRequired,
                  ),
                ),

                IconButton(
                  onPressed: () => context.dialogWith<WorkingTimeDto>(
                    child: _WorkTimeForm(),
                    onResult: controller.addValue,
                  ),
                  icon: Icon(
                    Symbols.add_circle_outline,
                    color: AppColors.greenLight,
                  ),
                ),
              ],
            ),

            ValueListenableBuilder(
              valueListenable: controller,
              builder: (_, value, __) {
                return Column(
                  spacing: 4.h,

                  children: value.map((time) {
                    final day = time.dayController.value ?? '';
                    final startTime =
                        time.startTimeController.value
                            ?.toFormattedTime() ??
                        '';
                    final endTime =
                        time.endTimeController.value
                            ?.toFormattedTime() ??
                        '';

                    return Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.greyDark),
                      ),
                      child: Row(
                        spacing: 4.w,
                        children: [
                          Expanded(
                            child: Text(
                              day.tr(context),
                              style: AppTextStyles.medium.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),

                          Text(
                            '$startTime - $endTime',
                            style: AppTextStyles.normal.copyWith(
                              color: AppColors.white,
                            ),
                          ),

                          widthSpace(8),
                          InkWell(
                            child: Icon(
                              Symbols.delete,
                              color: AppColors.red,
                            ),
                            onTap: () => controller.removeValue(time),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            if (state.hasError) FormFieldError(state.errorText!),
          ],
        );
      },
    );
  }
}

class _WorkTimeForm extends StatelessWidget {
  final _dto = WorkingTimeDto();

  _WorkTimeForm([WorkingTimeDto? dto]) {
    if (dto != null) _dto.getCopyFrom(dto);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _dto.formKey,
      child: Container(
        padding: EdgeInsets.all(16.r),
        margin: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          spacing: 12.h,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppDropDownField(
              controller: _dto.dayController,
              itemsBuilder: (_) => AppData.weekDays,
              itemToString: (item) => item.tr(context),
              label: 'Day',
              hintText: 'Select a day',
              isRequired: true,
            ),

            Row(
              spacing: 8.w,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: AppTimePicker(
                    controller: _dto.startTimeController,
                    isRequired: true,
                    prefixIcon: Symbols.access_time,
                    validator: (value) {
                      if (value == null) return '';

                      if (_dto.startTimeController.value != null &&
                          _dto.endTimeController.value != null &&
                          _dto.startTimeController.value!.isAfter(
                            _dto.endTimeController.value!,
                          )) {
                        return 'Start time must be before end time';
                      }
                      return null;
                    },
                  ),
                ),

                Text(
                  'to'.tr(context),
                  style: AppTextStyles.normal.copyWith(
                    color: AppColors.white,
                  ),
                ),

                Expanded(
                  child: AppTimePicker(
                    controller: _dto.endTimeController,
                    isRequired: true,
                    prefixIcon: Symbols.access_time,
                    validator: (value) {
                      if (value == null) return '';

                      if (_dto.startTimeController.value != null &&
                          _dto.endTimeController.value != null &&
                          _dto.startTimeController.value!.isAfter(
                            _dto.endTimeController.value!,
                          )) {
                        return 'End time must be after start time';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 12.w,
              children: [
                AppButton.secondary(
                  text: 'Cancel',
                  onPressed: () => context.back(),
                ),

                AppButton.primary(
                  text: 'Save',
                  onPressed: () {
                    if (_dto.formKey.currentState?.validate() ??
                        false) {
                      context.back(_dto);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
