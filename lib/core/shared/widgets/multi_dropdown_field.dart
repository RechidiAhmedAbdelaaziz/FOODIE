import 'package:app/core/shared/editioncontollers/list_generic_editingcontroller.dart';
import 'package:app/core/shared/widgets/form_field_props.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/core/themes/colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

class AppMultiDropDownField<T> extends StatelessWidget {
  final ListEditingController<T> controller;

  final String? label;
  final String? hintText;

  final List<T> Function(BuildContext context) itemsBuilder;
  final Widget Function(T)? itemToWidget;

  final String Function(T) itemToString;
  final String? Function(List<T>?)? validator;
  final VoidCallback? onAdd;

  final bool isRequired;

  final double width;

  const AppMultiDropDownField({
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
      child: FormField<List<T>>(
        validator: (value) => validator?.call(controller.value),
        autovalidateMode: AutovalidateMode.onUnfocus,
        builder: (state) {
          return Column(
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
              DropdownSearch<T>.multiSelection(
                items: (_, _) => items,

                selectedItems: controller.value,

                itemAsString: itemToString,
                compareFn: (item1, item2) => item1 == item2,
                onChanged: (list) {
                  
                  list = list.where((item) {
                    return items.contains(item);
                  }).toList();

                  controller.setList(list);
                },

                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                  cacheItems: true,
                  checkBoxBuilder:
                      (context, item, isDisabled, isSelected) {
                        return Checkbox(
                          value: isSelected,
                          onChanged: (_) {},
                          activeColor: AppColors.greenLight,
                        );
                      },
                  showSelectedItems: true,

                  showSearchBox: true,
                  searchDelay: const Duration(seconds: 1),
                  searchFieldProps: TextFieldProps(
                    cursorColor: AppColors.greenLight,

                    style: AppTextStyles.medium.copyWith(
                      color: AppColors.white,
                    ),
                    decoration: InputDecoration(
                      fillColor: AppColors.black,
                      filled: true,
                      hintText: 'Search',
                      hintStyle: AppTextStyles.medium.copyWith(
                        color: AppColors.grey,
                      ),
                      prefixIcon: Icon(
                        Symbols.search,
                        color: AppColors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 16.h,
                      ),
                    ),
                  ),

                  modalBottomSheetProps: ModalBottomSheetProps(
                    isScrollControlled: true,
                    useRootNavigator: true,
                    useSafeArea: true,
                    backgroundColor: AppColors.black,
                    barrierColor: AppColors.black.withAlpha(120),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12.r),
                      ),
                    ),
                  ),

                  // validationBuilder: (context, items) {
                  //   return SizedBox(
                  //     child: AppButton.primary(
                  //       text: 'Done',
                  //       onPressed: () {
                  //         Navigator.of(context).pop();
                  //         controller.setList(items);
                  //       },
                  //     ),
                  //   );
                  // },
                  containerBuilder: (context, popupWidget) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      //add margin to avoid the border and the keyboard
                      margin: EdgeInsets.only(top: 24.h),

                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12.r),
                        ),
                        border: Border(
                          top: BorderSide(
                            color: AppColors.greenLight,
                          ),
                        ),
                      ),
                      child: popupWidget,
                    );
                  },

                  itemBuilder:
                      (context, item, isDisabled, isSelected) {
                        return itemToWidget != null
                            ? itemToWidget!(item)
                            : Container(
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
                                child: Text(
                                  itemToString(item),
                                  style: AppTextStyles.normal
                                      .copyWith(
                                        color: AppColors.white,
                                      ),
                                ),
                              );
                      },
                ),

                dropdownBuilder: (context, selectedItems) {
                  if (selectedItems.isNotEmpty) {
                    return Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: selectedItems
                          .map(
                            (item) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),

                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.white,
                                ),
                                borderRadius: BorderRadius.circular(
                                  8.r,
                                ),
                              ),
                              child: Text(
                                itemToString(item),
                                style: AppTextStyles.small.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  }
                  return Text(
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
