import 'package:app/core/extensions/date_formatter.dart';
import 'package:app/core/extensions/snackbar.extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/shared/widgets/pagination_builder.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/history/data/model/history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../logic/history_cubit.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static RouteBase route = GoRoute(
    path: AppRoutes.history.path,
    builder: (context, state) => BlocProvider(
      create: (_) => HistoryCubit()..fetchHistory(),
      child: const HistoryScreen(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<HistoryCubit, HistoryState>(
      listener: (context, state) {
        state.onError(context.showErrorSnackbar);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Symbols.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('History'.tr(context)),
        ),
        body: PaginationBuilder(
          items: (ctx) =>
              ctx.select((HistoryCubit cubit) => cubit.histories),

          itemBuilder: _buildHistoryCard,

          isLoading: (ctx) => ctx.select(
            (HistoryCubit cubit) => cubit.state.isLoading,
          ),

          onLoadMore: () =>
              context.read<HistoryCubit>().fetchHistory(),

          onRefresh: () async =>
              context.read<HistoryCubit>().clearAndFetchHistory(),

          emptyText: 'No history found',
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, HistoryModel item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Symbols.calendar_month,
            color: AppColors.white,
            size: 24.sp,
          ),
          widthSpace(4),
          Expanded(
            child: Text(
              item.date?.toFormattedDate() ?? 'Unknown Date',
              style: AppTextStyles.medium.copyWith(
                color: AppColors.white,
              ),
            ),
          ),

          Text(
            item.amount?.toString() ?? '0',
            style: AppTextStyles.normal.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          widthSpace(2),
          Text(
            'DA'.tr(context),
            style: AppTextStyles.small.copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
