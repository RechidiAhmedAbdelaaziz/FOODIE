import 'package:app/core/constants/data.dart';
import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/snackbar.extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/services/filepicker/file_picker_service.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/shared/widgets/app_text_field.dart';
import 'package:app/core/shared/widgets/dropdown_field.dart';
import 'package:app/core/shared/widgets/image_field.dart';
import 'package:app/core/shared/widgets/multi_dropdown_field.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/restaurant/modules/restaurantform/logic/restaurant_form_cubit.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class RestaurantFormScreen extends StatelessWidget {
  const RestaurantFormScreen({super.key});

  static RouteBase get route => GoRoute(
    path: AppRoutes.updateRestaurant.path,
    builder: (context, state) => BlocProvider(
      create: (context) => RestaurantFormCubit()..init(),
      child: const RestaurantFormScreen(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<RestaurantFormCubit, RestaurantFormState>(
      listener: (context, state) {
        state.onError(context.showErrorSnackbar);
        state.onSuccess((_) {
          context.pop();
          context.showSuccessSnackbar(
            'Restaurant updated successfully'.tr(context),
          );
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Restaurant management'.tr(context)),
          centerTitle: true,
        ),
        body: Builder(
          builder: (context) {
            final isLoading = context.select(
              (RestaurantFormCubit cubit) =>
                  cubit.state.isLoading || !cubit.state.isLoaded,
            );
            return isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.green,
                    ),
                  )
                : Builder(
                    builder: (context) {
                      final dto = context
                          .read<RestaurantFormCubit>()
                          .dto;
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          child: Form(
                            key: dto.formKey,
                            child: Column(
                              spacing: 12.h,
                              children: [
                                AppFileField(
                                  controller: dto.imageController,
                                  height: 180.h,
                                  width: double.infinity - 40.w,
                                  borderRadius: 12.r,
                                  errorText: 'Image is required'.tr(
                                    context,
                                  ),
                                  picker: locator<ImageFilePicker>(),
                                  isRequired: true,
                                ),

                                AppTextField(
                                  controller: dto.nameController,
                                  hintText: 'Enter restaurant name',
                                  keyboardType: TextInputType.text,
                                  validator: (value) =>
                                      value?.isEmpty == true
                                      ? 'Name is required'
                                      : null,
                                ),

                                AppTextField(
                                  controller:
                                      dto.descriptionController,
                                  hintText:
                                      'Enter restaurant description',
                                  keyboardType:
                                      TextInputType.multiline,
                                  validator: (value) =>
                                      value?.isEmpty == true
                                      ? 'Description is required'
                                      : null,
                                ),

                                AppMultiDropDownField(
                                  controller: dto.categoryController,
                                  itemsBuilder: (_) =>
                                      AppData.restaurantTypes,
                                  hintText: 'Select restaurant type',
                                  itemToString: (value) =>
                                      value.tr(context),
                                ),

                                AppMultiDropDownField(
                                  controller:
                                      dto.openingDaysController,
                                  itemsBuilder: (_) =>
                                      AppData.weekDays,
                                  itemToString: (value) =>
                                      value.tr(context),

                                  hintText: 'Select opening days',
                                  validator: (value) =>
                                      value?.isEmpty == true
                                      ? 'Opening days are required'
                                      : null,
                                ),

                                Row(
                                  spacing: 12.w,
                                  children: [
                                    Expanded(
                                      child: AppDropDownField(
                                        controller:
                                            dto.startTimeController,
                                        itemsBuilder: (_) =>
                                            AppData.dayTimes,
                                        hintText: 'Select start time',
                                        itemToString: (value) =>
                                            value,
                                        validator: (value) =>
                                            value?.isEmpty == true
                                            ? 'Start time is required'
                                            : null,
                                      ),
                                    ),
                                    Text(
                                      'to'.tr(context),
                                      style: AppTextStyles.normal
                                          .copyWith(
                                            color: AppColors.white,
                                          ),
                                    ),
                                    Expanded(
                                      child: AppDropDownField(
                                        controller:
                                            dto.endTimeController,
                                        itemsBuilder: (_) =>
                                            AppData.dayTimes,
                                        hintText: 'Select end time',
                                        itemToString: (hour) => hour,
                                        validator: (value) =>
                                            value?.isEmpty == true
                                            ? 'End time is required'
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),

                                // GOOGLE map link like this https://maps.app.goo.gl/H38MqmYr61rkgMsC6
                                AppTextField(
                                  controller: dto.addressController,
                                  hintText:
                                      'Enter restaurant address link',
                                  keyboardType: TextInputType.text,
                                  suffixIcon: Symbols.location_on,
                                  validator: (value) =>
                                      value?.isEmpty == true
                                      ? 'Address is required'
                                      : value!.startsWith(
                                          'https://maps.app.goo.gl/',
                                        )
                                      ? null
                                      : 'Invalid google map link',
                                ),

                                //check box for prepaid
                                ValueListenableBuilder(
                                  valueListenable:
                                      dto.isPrePaidController,
                                  builder: (context, value, child) {
                                    return CheckboxListTile(
                                      title: Text(
                                        'Is Prepaid'.tr(context),
                                        style: AppTextStyles.normal
                                            .copyWith(
                                              color: AppColors.white,
                                            ),
                                      ),
                                      value: value,
                                      onChanged: (value) {
                                        dto.isPrePaidController
                                            .setValue(value ?? false);
                                      },
                                      activeColor: AppColors.green,
                                      checkColor: AppColors.white,
                                    );
                                  },
                                ),

                                AppTextField(
                                  controller: dto.phoneController,
                                  hintText: 'Enter phone number',
                                  keyboardType: TextInputType.phone,
                                  suffixIcon: Symbols.phone,
                                  validator: (value) =>
                                      value?.isEmpty == true
                                      ? 'Phone number is required'
                                      : null,
                                ),

                                AppTextField(
                                  controller:
                                      dto.facebookLinkController,
                                  hintText: 'Enter Facebook link',
                                  keyboardType: TextInputType.url,
                                  suffixWidget: SvgPicture.asset(
                                    Assets.svg.facebook,
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                ),

                                AppTextField(
                                  controller:
                                      dto.instagramLinkController,
                                  hintText: 'Enter Instagram link',
                                  keyboardType: TextInputType.url,
                                  suffixWidget: SvgPicture.asset(
                                    Assets.svg.instagram,
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                ),

                                AppTextField(
                                  controller:
                                      dto.tiktokLinkController,
                                  hintText: 'Enter TikTok link',
                                  keyboardType: TextInputType.url,
                                  suffixWidget: SvgPicture.asset(
                                    Assets.svg.tiktok,
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                ),

                                heightSpace(12),
                                AppButton.primary(
                                  text: 'Save',
                                  onPressed: context
                                      .read<RestaurantFormCubit>()
                                      .save,
                                ),
                                SizedBox(
                                  height: MediaQuery.of(
                                    context,
                                  ).viewInsets.bottom,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
