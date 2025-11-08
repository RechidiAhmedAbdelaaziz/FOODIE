import 'package:app/core/extensions/snackbar.extension.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/features/staff/data/model/staff_model.dart';
import 'package:app/features/staff/modules/staffform/logic/staff_form_cubit.dart';
import 'package:app/features/staff/modules/staffform/ui/widget/staff_form_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateStaffForm extends StatelessWidget {
  final StaffModel staff;

  const UpdateStaffForm({super.key, required this.staff});

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
              (UpdateStaffFormCubit cubit) => !cubit.state.isLoaded,
            );

            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final dto = context.read<UpdateStaffFormCubit>().dto;

            return StaffFormView(
              formKey: dto.formKey,
              nameController: dto.nameController,
              loginController: dto.loginController,
              onSave: context.read<UpdateStaffFormCubit>().save,
              isLoading: context.select(
                (UpdateStaffFormCubit cubit) => cubit.state.isLoading,
              ),
            );
          },
        ),
      ),
    );
  }
}
