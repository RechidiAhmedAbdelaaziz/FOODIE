import 'package:app/core/shared/editioncontollers/generic_editingcontroller.dart';
import 'package:app/core/shared/widgets/form_field_props.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/core/themes/colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

class AppDropDownField<T> extends StatelessWidget {
  final EditingController<T> controller;

  final String? label;
  final String? hintText;

  final List<T> Function(BuildContext context) itemsBuilder;
  final Widget Function(T)? itemToWidget;

  final String Function(T) itemToString;
  final String? Function(T?)? validator;
  final VoidCallback? onAdd;

  final bool isRequired;

  final double width;

  const AppDropDownField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.validator,
    this.onAdd,
    this.isRequired = false,
    required this.itemsBuilder,
    required this.itemToString,
    this.itemToWidget,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final items = itemsBuilder(context);
    return SizedBox(
      width: width,
      child: FormField<T>(
        validator: (value) => validator?.call(controller.value),
        autovalidateMode: AutovalidateMode.onUnfocus,
        builder: (state) {
          return Column(
            spacing: 8.h,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: 8.w),
                child: Row(
                  children: [
                    Expanded(
                      child: label != null
                          ? FormFieldLabel(
                              label!,
                              isRequired: isRequired,
                            )
                          : SizedBox.shrink(),
                    ),

                    if (onAdd != null) ...[
                      InkWell(
                        // Add button
                        onTap: onAdd,
                        child: Icon(
                          Symbols.add_circle_outline,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              DropdownSearch<T>(
                itemAsString: itemToString,
                selectedItem: controller.value,
                compareFn: (item1, item2) => item1 == item2,

                items: (filter, loadProps) => items,

                onChanged: (value) => value != null
                    ? controller.setValue(value)
                    : controller.clear(),

                decoratorProps: DropDownDecoratorProps(
                  baseStyle: AppTextStyles.medium.copyWith(
                    color: AppColors.black,
                  ),

                  decoration: InputDecoration(
                    fillColor: AppColors.blue,
                    filled: true,

                    hintText: hintText,
                    error: state.hasError
                        ? FormFieldError(state.errorText!)
                        : null,

                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 12.w,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: state.hasError
                          ? BorderSide(
                              color: AppColors.red,
                              width: 1.w,
                            )
                          : BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
