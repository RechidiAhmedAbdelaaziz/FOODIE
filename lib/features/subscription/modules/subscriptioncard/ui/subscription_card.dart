import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/date_formatter.dart';
import 'package:app/core/extensions/snackbar.extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/subscription/data/models/subscription_model.dart';
import 'package:app/features/subscription/data/repository/subscription_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

class SubscriptionCard extends StatefulWidget {
  const SubscriptionCard({super.key});

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  SubscriptionModel? subscription;

  @override
  void initState() {
    locator<SubscriptionRepo>().getMySubscription().then((result) {
      result.when(
        success: (subscription) =>
            setState(() => this.subscription = subscription),
        error: (error) => context.showErrorSnackbar(error.message),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = (subscription != null && subscription!.isActive);
    return Column(
      spacing: 8.w,
      children: [
        Text(
          'Your subscription expires on :'.tr(context),
          style: AppTextStyles.normal.copyWith(color: Colors.white),
        ),

        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 4.h,
          ),
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 12.w,
            children: [
              Icon(
                Symbols.calendar_today,
                color: Colors.white,
                size: 24.sp,
              ),
              Text(
                isActive
                    ? subscription!.expirationDate.toDdMmYyyy()
                    : 'Expired'.tr(context),

                style: AppTextStyles.large.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
