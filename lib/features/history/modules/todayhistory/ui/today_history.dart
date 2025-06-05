import 'package:app/core/di/locator.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/history/data/model/history_model.dart';
import 'package:app/features/history/data/repository/history_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TodayHistory extends StatefulWidget {
  const TodayHistory({super.key});

  @override
  State<TodayHistory> createState() => _TodayHistoryState();
}

class _TodayHistoryState extends State<TodayHistory> {
  HistoryModel? _history;
  bool isLoading = true;

  @override
  void initState() async {
    final result = await locator<HistoryRepo>().getLastHistory();

    result.when(
      success: (history) => setState(() {
        _history = history;
        isLoading = false;
      }),
      error: (_) => setState(() => isLoading = false),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today Income'.tr(context),
            style: AppTextStyles.medium.copyWith(
              color: AppColors.white,
            ),
          ),

          heightSpace(8),
          isLoading
              ? SizedBox(
                  height: 4.h,
                  child: LinearProgressIndicator(
                    color: AppColors.green,
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text(
                        _history!.amount?.toString() ?? '0',
                        style: AppTextStyles.large.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.greenLight,
                        ),
                      ),
                    ),
                    widthSpace(4),
                    Text(
                      'DZD'.tr(context),
                      style: AppTextStyles.normal.copyWith(
                        color: AppColors.greenLight,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
