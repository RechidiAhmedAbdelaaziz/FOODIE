import 'package:app/core/constants/data.dart';
import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/snackbar.extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/app_route.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/services/filepicker/file_picker_service.dart';
import 'package:app/core/shared/editioncontollers/list_generic_editingcontroller.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/shared/widgets/app_text_field.dart';
import 'package:app/core/shared/widgets/dropdown_field.dart';
import 'package:app/core/shared/widgets/image_field.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/food/data/dto/food_dto.dart';
import 'package:app/features/food/data/model/food_model.dart';
import 'package:app/features/food/modules/foodform/logic/food_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class UpdateFoodFormParams extends RouteParams {
  UpdateFoodFormParams(FoodModel food)
    : super(pathParams: {'id': food.id!});
}

class FoodFormScreen extends StatelessWidget {
  const FoodFormScreen({super.key});

  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.createFood.path,
      builder: (context, state) => BlocProvider(
        create: (context) => FoodFormCubit()..init(),
        child: const FoodFormScreen(),
      ),
    ),

    GoRoute(
      path: AppRoutes.updateFood.path,
      builder: (context, state) {
        final foodId = state.pathParameters['id']!;
        return BlocProvider(
          create: (context) => FoodFormCubit()..init(foodId),
          child: const FoodFormScreen(),
        );
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<FoodFormCubit, FoodFormState>(
      listener: (context, state) {
        state.onError(context.showErrorSnackbar);
        state.onSuccess(context.back);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Menu management'.tr(context)),
          leading: IconButton(
            onPressed: context.back,
            icon: const Icon(Symbols.arrow_back),
          ),
        ),

        body: Builder(
          builder: (context) {
            final isLoading = context.select(
              (FoodFormCubit cubit) => cubit.state.isLoading,
            );

            final dto = context.read<FoodFormCubit>().dto;
            return isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.green,
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Form(
                        key: dto.formKey,
                        child: Column(
                          spacing: 12.h,
                          children: [
                            AppFileField(
                              controller: dto.imageController,
                              height: 150.h,
                              width: 120.w,
                              borderRadius: 16.r,
                              isRequired: true,
                              errorText: 'Image is required'.tr(
                                context,
                              ),
                              picker: locator<ImageFilePicker>(),
                            ),

                            AppTextField(
                              controller: dto.nameController,
                              label: 'Product name'.tr(context),
                              isRequired: true,
                              keyboardType: TextInputType.text,
                              validator: (value) =>
                                  value?.isEmpty == true
                                  ? 'Name is required'.tr(context)
                                  : null,
                            ),

                            AppTextField(
                              controller: dto.descriptionController,
                              label: 'Description'.tr(context),
                              isRequired: true,
                              keyboardType: TextInputType.multiline,
                              validator: (value) =>
                                  value?.isEmpty == true
                                  ? 'Description is required'.tr(
                                      context,
                                    )
                                  : null,
                            ),

                            AppTextField(
                              controller: dto.priceController,
                              label: 'Price'.tr(context),
                              isRequired: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly,
                              ],
                              validator: (value) {
                                final price = int.tryParse(
                                  value ?? '',
                                );
                                return price == null || price <= 0
                                    ? 'Price must be a positive number'
                                          .tr(context)
                                    : null;
                              },
                            ),

                            AppDropDownField(
                              controller: dto.categoryController,
                              itemsBuilder: (_) => AppData
                                  .categories, //TODO: create category list
                              itemToString: (item) =>
                                  item.tr(context),
                              isRequired: true,
                              label: 'Category'.tr(context),
                              hintText: 'Select a category'.tr(
                                context,
                              ),
                            ),

                            ValueListenableBuilder(
                              valueListenable: dto.addOnsController,
                              builder: (context, addOnsDto, child) {
                                return Column(
                                  spacing: 4.h,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Add-ons'.tr(context),
                                            style: AppTextStyles
                                                .xLarge
                                                .copyWith(
                                                  color:
                                                      AppColors.white,
                                                ),
                                          ),
                                        ),

                                        IconButton(
                                          onPressed: () {
                                            dto.addOnsController
                                                .addValue(
                                                  AddOnsDTO(),
                                                );
                                          },
                                          icon: const Icon(
                                            Symbols
                                                .add_circle_outline,
                                          ),
                                          color: AppColors.green,
                                        ),
                                      ],
                                    ),

                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: addOnsDto.length,
                                      itemBuilder: (context, index) {
                                        final addOn =
                                            addOnsDto[index];
                                        return _AddOnsField(
                                          addOn,
                                          dto.addOnsController,
                                        );
                                      },
                                      separatorBuilder:
                                          (context, index) =>
                                              heightSpace(8.h),
                                    ),
                                  ],
                                );
                              },
                            ),

                            AppButton.primary(
                              text: 'Save',
                              onPressed: context
                                  .read<FoodFormCubit>()
                                  .save,
                            ),

                            heightSpace(
                              MediaQuery.of(
                                    context,
                                  ).viewInsets.bottom +
                                  16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class _AddOnsField extends StatelessWidget {
  final AddOnsDTO dto;
  final ListEditingController<AddOnsDTO> addOnsController;

  const _AddOnsField(this.dto, this.addOnsController);

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4.w,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: AppTextField(
            controller: dto.nameController,
            hintText: 'Add-on name'.tr(context),
            isRequired: true,
            keyboardType: TextInputType.text,
            validator: (value) => value?.isEmpty == true
                ? 'Name is required'.tr(context)
                : null,
          ),
        ),

        Expanded(
          child: AppTextField(
            controller: dto.priceController,
            hintText: 'Price'.tr(context),
            isRequired: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              final price = int.tryParse(value ?? '');
              return price == null || price < 0
                  ? 'Price must be a positive number'.tr(context)
                  : null;
            },
          ),
        ),

        InkWell(
          onTap: () => addOnsController.removeValue(dto),
          child: const Icon(Symbols.delete, color: AppColors.red),
        ),
      ],
    );
  }
}
