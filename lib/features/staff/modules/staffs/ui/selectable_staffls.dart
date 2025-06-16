import 'package:app/core/extensions/list_extenstion.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/shared/widgets/pagination_builder.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/staff/data/model/staff_model.dart';
import 'package:app/features/staff/modules/staffs/logic/staffs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectableStaffs extends StatefulWidget {
  final List<StaffModel> selected;
  const SelectableStaffs(this.selected, {super.key});

  @override
  State<SelectableStaffs> createState() => _SelectableStaffsState();
}

class _SelectableStaffsState extends State<SelectableStaffs> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StaffsCubit()..fetchStaffs(),
      child: Builder(
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 8.h,
            ),
            height: 600.h,
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              spacing: 16.h,
              children: [
                Text(
                  'Select Staffs',
                  style: AppTextStyles.large.copyWith(
                    color: AppColors.white,
                  ),
                ),

                Expanded(
                  child: PaginationBuilder(
                    items: (ctx) => ctx.select(
                      (StaffsCubit cubit) => cubit.state.staffs,
                    ),
                    itemBuilder: _buildStaffCard,

                    isLoading: (ctx) => ctx.select(
                      (StaffsCubit cubit) => cubit.state.isLoading,
                    ),

                    onLoadMore: () =>
                        context.read<StaffsCubit>().fetchStaffs(),

                    onRefresh: () async =>
                        context.read<StaffsCubit>().clearAndFetch(),

                    emptyText: 'No staffs found',
                  ),
                ),

                Row(
                  spacing: 16.w,
                  children: [
                    AppButton.secondary(
                      onPressed: context.back,
                      text: 'Cancel',
                    ),
                    AppButton.primary(
                      onPressed: () => context.back(widget.selected),
                      text: 'Select',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStaffCard(BuildContext context, StaffModel staff) {
    final isSelected = widget.selected.contains(staff);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greenLight),
        borderRadius: BorderRadius.circular(12.r),
      ),
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (checked) {
              if (checked == true) {
                widget.selected.addUnique(staff);
                setState(() {});
              } else {
                widget.selected.remove(staff);
                setState(() {});
              }
            },
            activeColor: AppColors.greenLight,
            checkColor: AppColors.black,
          ),
          widthSpace(12),
          Expanded(
            child: Text(
              staff.name ?? '',
              style: AppTextStyles.medium.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
