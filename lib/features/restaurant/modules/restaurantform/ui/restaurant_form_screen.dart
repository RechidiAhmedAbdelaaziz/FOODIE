import 'package:app/core/constants/data.dart';
import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/snackbar.extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/services/filepicker/file_picker_service.dart';
import 'package:app/core/shared/widgets/app_text_field.dart';
import 'package:app/core/shared/widgets/dropdown_field.dart';
import 'package:app/core/shared/widgets/image_field.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/features/restaurant/modules/restaurantform/logic/restaurant_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

                                AppDropDownField(
                                  controller: dto.categoryController,
                                  itemsBuilder: (_) =>
                                      AppData.restaurantTypes,
                                  itemToString: (value) =>
                                      value.tr(context),
                                ),

                                AppTextField(
                                  controller: dto.addressController,
                                  hintText:
                                      'Enter restaurant address',
                                  keyboardType: TextInputType.text,
                                  suffixIcon: Symbols.location_on,
                                  validator: (value) =>
                                      value?.isEmpty == true
                                      ? 'Address is required'
                                      : null,
                                ),

                                //check box for prepaid
                                CheckboxListTile(
                                  title: Text(
                                    'Is Prepaid'.tr(context),
                                  ),
                                  value:
                                      dto.isPrePaidController.value,
                                  onChanged: (value) {
                                    dto.isPrePaidController.setValue(
                                      value ?? false,
                                    );
                                  },
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
