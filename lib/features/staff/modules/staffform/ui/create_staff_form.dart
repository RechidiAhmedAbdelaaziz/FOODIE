import 'package:app/core/extensions/snackbar.extension.dart';
import 'package:app/core/router/routing_extension.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/features/staff/modules/staffform/logic/staff_form_cubit.dart';
import 'package:app/features/staff/modules/staffform/ui/widget/staff_form_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateStaffForm extends StatelessWidget {
  const CreateStaffForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateStaffFormCubit()..init(),
      child: BlocListener<CreateStaffFormCubit, StaffFormState>(
        listener: (context, state) {
          state.onError(context.showErrorSnackbar);
          state.onSuccess(context.back);
        },
        child: Builder(
          builder: (context) {
            final isLoading = context.select(
              (CreateStaffFormCubit cubit) => !cubit.state.isLoaded,
            );

            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.green,
                ),
              );
            }

            final dto = context.read<CreateStaffFormCubit>().dto;

            return StaffFormView(
              nameController: dto.nameController,
              loginController: dto.loginController,
              onSave: context.read<CreateStaffFormCubit>().save,
              isLoading: context.select(
                (CreateStaffFormCubit cubit) => cubit.state.isLoading,
              ),
            );
          },
        ),
      ),
    );
  }
}
