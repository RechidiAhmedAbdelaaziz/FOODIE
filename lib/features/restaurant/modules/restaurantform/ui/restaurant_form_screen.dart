import 'package:app/core/di/locator.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/services/filepicker/file_picker_service.dart';
import 'package:app/core/shared/widgets/image_field.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/features/restaurant/modules/restaurantform/logic/restaurant_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
    final isLoading = context.select(
      (RestaurantFormCubit cubit) => cubit.state.isLoading,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant management'.tr(context)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.green,
              ),
            )
          : Builder(
              builder: (context) {
                final dto = context.read<RestaurantFormCubit>().dto;
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: Form(
                      key: dto.formKey,
                      child: Column(
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
