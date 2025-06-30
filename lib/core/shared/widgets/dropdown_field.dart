import 'package:app/core/localization/localization_extension.dart';
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
  final IconData? onAddIcon;

  final bool isRequired;

  final double? width;

  const AppDropDownField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.validator,
    this.onAdd,
    this.onAddIcon,

    this.isRequired = false,
    required this.itemsBuilder,
    required this.itemToString,
    this.itemToWidget,
    this.width,
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
                          onAddIcon ?? Symbols.add_circle_outline,
                          color: AppColors.greenLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              GestureDetector(
                child: DropdownSearch<T>(
                  itemAsString: itemToString,
                  selectedItem: controller.value,
                  compareFn: (item1, item2) => item1 == item2,

                  items: (filter, loadProps) => items,

                  onChanged: (value) {
                    value != null
                        ? controller.setValue(value)
                        : controller.clear();
                  },

                  popupProps: PopupProps.menu(
                    cacheItems: true,
                    menuProps: MenuProps(
                      backgroundColor: AppColors.black,
                    ),

                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      style: AppTextStyles.normal.copyWith(
                        color: AppColors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search'.tr(context),
                        hintStyle: AppTextStyles.small.copyWith(
                          color: AppColors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                            color: AppColors.green,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                      ),
                    ),

                    showSelectedItems: false,
                    constraints: BoxConstraints(
                      maxHeight: 250.h,
                      maxWidth: double.infinity,
                    ),

                    containerBuilder: (context, popupWidget) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(12.r),
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.greenLight,
                            ),
                          ),
                        ),
                        child: popupWidget,
                      );
                    },
                    itemBuilder:
                        (context, item, isDisabled, isSelected) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 8.h,
                            ),
                            margin: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 8.h,
                            ),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: AppColors.blue,
                            ),

                            child: itemToWidget != null
                                ? itemToWidget!(item)
                                : Text(
                                    itemToString(item),
                                    style: AppTextStyles.normal
                                        .copyWith(
                                          color: AppColors.white,
                                        ),
                                  ),
                          );
                        },
                  ),

                  dropdownBuilder: (context, selectedItem) {
                    return selectedItem != null &&
                            itemToString(selectedItem).isNotEmpty
                        ? Text(
                            itemToString(selectedItem),
                            style: AppTextStyles.medium.copyWith(
                              color: AppColors.white,
                            ),
                          )
                        : Text(
                            hintText ?? '',
                            style: AppTextStyles.small.copyWith(
                              color: AppColors.grey,
                            ),
                          );
                  },

                  decoratorProps: DropDownDecoratorProps(
                    baseStyle: AppTextStyles.medium.copyWith(
                      color: AppColors.white,
                    ),

                    decoration: InputDecoration(
                      fillColor: AppColors.blue,
                      filled: true,

                      error: state.hasError
                          ? FormFieldError(state.errorText!)
                          : null,

                      suffixIconColor: AppColors.white,

                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 12.w,
                      ),
                      isCollapsed: true,
                      isDense: true,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12.r),
                        ),
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
              ),
            ],
          );
        },
      ),
    );
  }
}
