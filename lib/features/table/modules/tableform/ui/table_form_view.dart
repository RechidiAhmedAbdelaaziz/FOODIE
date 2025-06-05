import 'package:app/core/extensions/popup_extension.dart';
import 'package:app/core/extensions/snackbar.extension.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/shared/widgets/app_text_field.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/features/staff/modules/staffs/ui/selectable_staffls.dart';
import 'package:app/features/table/data/dto/table_dto.dart';
import 'package:app/features/table/data/model/table_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../logic/table_form_cubit.dart';

class TableFormView extends StatelessWidget {
  final TableModel? table;
  const TableFormView({super.key, this.table});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TableFormCubit()..init(table?.id),
      child: BlocListener<TableFormCubit, TableFormState>(
        listener: (context, state) {
          state.onError(context.showErrorSnackbar);
          state.onSuccess(context.back);
        },
        child: Builder(
          builder: (context) {
            final isLoading = context.select(
              (TableFormCubit cubit) =>
                  cubit.state.isLoading || !cubit.state.isLoaded,
            );
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
              child: isLoading
                  ? _buildLoadingIndicator()
                  : _TableFormContent(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: 4.h,
      child: LinearProgressIndicator(color: AppColors.green),
    );
  }
}

class _TableFormContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dto = context.read<TableFormCubit>().dto;
    return Form(
      key: dto.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: dto.nameController,
            label: 'Name',
            hintText: 'Enter table name',
            prefixIcon: Symbols.table_bar,
            keyboardType: TextInputType.name,
            isRequired: true,
            validator: (value) => (value == null || value.isEmpty)
                ? 'Name is required'
                : null,
          ),
          heightSpace(12),

          ValueListenableBuilder<bool>(
            valueListenable: dto.forAllStaffController,
            builder: (context, isForAll, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: Text(
                      'For All Staff',
                      style: TextStyle(color: AppColors.white),
                    ),
                    value: isForAll,
                    onChanged: dto.forAllStaffController.setValue,
                  ),
                  if (!isForAll) ...[
                    SizedBox(height: 8.h),
                    _StaffSelection(dto: dto),
                  ],
                ],
              );
            },
          ),
          heightSpace(16),

          Row(
            spacing: 16.w,
            children: [
              AppButton.secondary(
                text: 'Cancel',
                onPressed: () => context.back(),
              ),

              AppButton.primary(
                text: 'Save',
                onPressed: context.read<TableFormCubit>().save,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StaffSelection extends StatelessWidget {
  final TableDTO dto;
  const _StaffSelection({required this.dto});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dto.staffController,
      builder: (context, staffs, _) {
        return Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            ...staffs.map<Widget>(
              (staff) => Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  staff.name ?? 'Unknown',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Symbols.edit_square, color: AppColors.green),
              onPressed: () {
                context.dialogWith(
                  child: SelectableStaffs(staffs),
                  onResult: dto.staffController.setList,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
