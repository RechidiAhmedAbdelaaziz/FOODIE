import 'package:app/core/extensions/popup_extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/shared/widgets/pagination_builder.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/staff/data/model/staff_model.dart';
import 'package:app/features/staff/modules/staffform/ui/create_staff_form.dart';
import 'package:app/features/staff/modules/staffform/ui/get_mount_form.dart';
import 'package:app/features/staff/modules/staffform/ui/update_staff_form.dart';
import 'package:app/features/staff/modules/staffs/logic/staffs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class StaffsScreen extends StatelessWidget {
  const StaffsScreen({super.key});

  static RouteBase get route => GoRoute(
    path: AppRoutes.staffs.path,
    builder: (context, state) {
      return BlocProvider(
        create: (context) => StaffsCubit()..fetchStaffs(),
        child: const StaffsScreen(),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.back,
          icon: const Icon(Symbols.arrow_back),
        ),
        title: Text('Staffs'.tr(context)),
        actions: [
          IconButton(
            onPressed: () => context.dialogWith<StaffModel>(
              child: CreateStaffForm(),
              onResult: context.read<StaffsCubit>().addStaff,
            ),
            icon: const Icon(
              Symbols.person_add,
              color: AppColors.white,
            ),
          ),
        ],
      ),

      body: PaginationBuilder(
        items: (ctx) => ctx.watch<StaffsCubit>().state.staffs,
        itemBuilder: _buildStaffCard,

        isLoading: (ctx) =>
            ctx.select((StaffsCubit cubit) => cubit.state.isLoading),

        onLoadMore: () => context.read<StaffsCubit>().fetchStaffs(),

        onRefresh: () async =>
            context.read<StaffsCubit>().clearAndFetch(),

        emptyText: 'No staffs found',
      ),
    );
  }

  Widget _buildStaffCard(BuildContext context, StaffModel staff) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greenLight),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  staff.name ?? '',
                  style: AppTextStyles.large.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),

              PopupMenuButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Symbols.more_vert,
                  color: AppColors.white,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Row(
                        spacing: 8.w,
                        children: [
                          const Icon(
                            Symbols.send_money,
                            color: AppColors.green,
                          ),
                          Text('I take'.tr(context)),
                        ],
                      ),
                      onTap: () => context.dialogWith<StaffModel>(
                        child: GetMountForm(staff: staff),
                        onResult: context
                            .read<StaffsCubit>()
                            .updateStaff,
                      ),
                    ),

                    PopupMenuItem(
                      child: Row(
                        spacing: 8.w,

                        children: [
                          const Icon(Symbols.edit),
                          Text('Edit'.tr(context)),
                        ],
                      ),
                      onTap: () => context.dialogWith(
                        child: UpdateStaffForm(staff: staff),
                        onResult: context
                            .read<StaffsCubit>()
                            .updateStaff,
                      ),
                    ),

                    PopupMenuItem(
                      child: Row(
                        spacing: 8.w,

                        children: [
                          const Icon(
                            Symbols.delete,
                            color: AppColors.red,
                          ),
                          Text('Delete'.tr(context)),
                        ],
                      ),
                      onTap: () => context.alertDialog(
                        title: 'Delete',
                        content:
                            'Are you sure you want to delete this staff?'
                                .tr(context),
                        onConfirm: () => context
                            .read<StaffsCubit>()
                            .removeStaff(staff),
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          heightSpace(12),

          Row(
            children: [
              Expanded(
                child: Text(
                  staff.login ?? 'Unknown Contact',
                  style: AppTextStyles.normal.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
              widthSpace(8),
              Text(
                staff.amount?.toString() ?? '0',
                style: AppTextStyles.normal.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.greenLight,
                ),
              ),
              widthSpace(4),
              Text(
                'DZD'.tr(context),
                style: AppTextStyles.small.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
