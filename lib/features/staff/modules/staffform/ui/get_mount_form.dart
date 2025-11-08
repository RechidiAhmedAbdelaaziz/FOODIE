import 'package:app/core/extensions/snackbar.extension.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/shared/widgets/app_text_field.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/features/staff/data/model/staff_model.dart';
import 'package:app/features/staff/modules/staffform/logic/staff_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class GetMountForm extends StatelessWidget {
  final StaffModel staff;
  const GetMountForm({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateStaffFormCubit()..init(staff),
      child: BlocListener<UpdateStaffFormCubit, StaffFormState>(
        listener: (context, state) {
          state.onError(context.showErrorSnackbar);
          state.onSuccess(context.back);
        },
        child: Builder(
          builder: (context) {
            final isLoading = context.select(
              (UpdateStaffFormCubit cubit) =>
                  !cubit.state.isLoaded || cubit.state.isLoading,
            );

            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final dto = context.read<UpdateStaffFormCubit>().dto;

            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 8.h,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(32.r),
              ),
              child: Form(
                key: dto.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTextField(
                      controller: dto.mountGottenController,
                      hintText: 'Enter mount gotten',
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^[0-9]*\.?[0-9]*$'),
                        ),
                      ],
                      isRequired: true,
                      prefixIcon: Symbols.money,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mount gotten is required';
                        }
                        final doubleValue = int.tryParse(value);
                        if (doubleValue == null || doubleValue < 0) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    heightSpace(24),

                    Row(
                      spacing: 16.w,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppButton.secondary(
                          text: 'Cancel',
                          onPressed: () => context.back(),
                        ),

                        AppButton.primary(
                          text: 'Save',
                          onPressed: context
                              .read<UpdateStaffFormCubit>()
                              .save,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
