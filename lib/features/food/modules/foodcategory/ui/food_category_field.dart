import 'package:app/core/extensions/bottom_extension.dart';
import 'package:app/core/extensions/popup_extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/shared/editioncontollers/generic_editingcontroller.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/shared/widgets/app_text_field.dart';
import 'package:app/core/shared/widgets/dropdown_field.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../logic/food_category_cubit.dart';

class FoodCategoryField extends StatelessWidget {
  final EditingController<String> controller;
  const FoodCategoryField(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodCategoryCubit()..fetchFoodCategories(),
      child: Builder(
        builder: (context) {
          return AppDropDownField(
            controller: controller,
            label: 'Select Category'.tr(context),
            itemsBuilder: (context) =>
                context.watch<FoodCategoryCubit>().state.categories,
            itemToString: (value) => value.tr(context),
            hintText: 'Select Category'.tr(context),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Select Category'.tr(context);
              }
              return null;
            },
            onAddIcon: Symbols.settings_suggest,
            onAdd: () {
              context.bottomSheet(
                child: BlocProvider.value(
                  value: context.read<FoodCategoryCubit>(),
                  child: const _CategoriesManagment(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CategoriesManagment extends StatelessWidget {
  const _CategoriesManagment();

  @override
  Widget build(BuildContext context) {
    final categories = context
        .watch<FoodCategoryCubit>()
        .state
        .categories;
    // Wrap of categories in Wrap widget to display them in a horizontal list
    // user can edit or delete categories and add new categories
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 400.h),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widthSpace(12),
              Text(
                'Food Categories'.tr(context),
                style: AppTextStyles.large.copyWith(
                  color: AppColors.white,
                ),
              ),
              const Spacer(),

              IconButton(
                icon: Icon(Symbols.close, color: AppColors.red),
                onPressed: () => context.back(),
              ),
            ],
          ),

          Container(
            constraints: BoxConstraints(maxHeight: 300.h),
            width: double.infinity,

            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,

                children: [
                  IconButton(
                    onPressed: () {
                      context.dialogWith<String>(
                        child: _CategeoryForm(),
                        onResult: (value) {
                          context
                              .read<FoodCategoryCubit>()
                              .createFoodCategory(value);
                        },
                      );
                    },
                    icon: Icon(
                      Symbols.add_circle_outline,
                      color: AppColors.green,
                    ),
                  ),
                  for (final category in categories)
                    _buildCategoryChip(
                      context,
                      category: category,
                      onDelete: () => context
                          .read<FoodCategoryCubit>()
                          .deleteFoodCategory(category),
                      onEdit: () {
                        context.dialogWith<String>(
                          child: _CategeoryForm(category),
                          onResult: (value) {
                            context
                                .read<FoodCategoryCubit>()
                                .updateFoodCategory(category, value);
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context, {
    required String category,
    required VoidCallback onDelete,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.w,
        children: [
          Text(
            category.tr(context),
            style: AppTextStyles.medium.copyWith(
              color: AppColors.white,
            ),
          ),

          InkWell(
            onTap: onEdit,
            child: Icon(
              Symbols.edit,
              color: AppColors.greenLight,
              size: 20.w,
            ),
          ),

          InkWell(
            onTap: () => context.alertDialog(
              title: '${'Delete'.tr(context)} $category',
              content:
                  'Are you sure you want to delete this category?'.tr(
                    context,
                  ),
              onConfirm: onDelete,
            ),
            child: Icon(
              Symbols.delete,
              color: AppColors.red,
              size: 20.w,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategeoryForm extends StatefulWidget {
  final String? initialName;
  const _CategeoryForm([this.initialName]);

  @override
  State<_CategeoryForm> createState() => __CategeoryFormState();
}

class __CategeoryFormState extends State<_CategeoryForm> {
  late final TextEditingController _nameController;
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.initialName);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20.h,
          children: [
            AppTextField(
              controller: _nameController,
              label: 'Category Name'.tr(context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Category Name is required'.tr(context);
                }
                return null;
              },
            ),

            Row(
              spacing: 12.w,
              children: [
                Expanded(
                  child: AppButton.secondary(
                    text: 'Cancel',
                    onPressed: () => context.back(),
                  ),
                ),

                Expanded(
                  child: AppButton.primary(
                    text: 'Save',
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      context.back(_nameController.text);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
