import 'package:app/core/constants/data.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/shared/widgets/check_box_field.dart';
import 'package:app/core/shared/widgets/dropdown_field.dart';
import 'package:app/core/shared/widgets/time_picker.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/restaurant/data/dto/restaurant_filter_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';

class RestaurantFiltersView extends StatefulWidget {
  final RestaurantFilterDTO _dto;

  RestaurantFiltersView(RestaurantFilterDTO dto, {super.key})
    : _dto = RestaurantFilterDTO(type: dto.type)..copyFrom(dto);

  @override
  State<RestaurantFiltersView> createState() =>
      _RestaurantFiltersViewState();
}

class _RestaurantFiltersViewState
    extends State<RestaurantFiltersView> {
  late final bool _disposeOnPop;

  @override
  dispose() {
    super.dispose();
    if (_disposeOnPop) {
      widget._dto.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    // This widget shown in bottom sheet
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        _disposeOnPop = didPop && result is! RestaurantFilterDTO;
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.r),
          ),
        ),
        child: Column(
          spacing: 16.h,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Filters'.tr(context),
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.greenLight,
                  ),
                ),
                const Spacer(),

                IconButton(
                  icon: const Icon(Symbols.refresh),
                  color: AppColors.white,
                  onPressed: widget._dto.clear,
                ),
              ],
            ),
            const Divider(color: AppColors.green, height: 12),

            // Working Days
            AppDropDownField(
              controller: widget._dto.workingDaysController,
              itemsBuilder: (_) => AppData.weekDays,
              itemToString: (weekDay) => weekDay.tr(context),
              label: 'Working Days'.tr(context),
              hintText: 'Select a Days'.tr(context),
            ),

            // Opening and Closing Time
            Row(
              spacing: 8.w,
              children: [
                Expanded(
                  child: AppTimePicker(
                    controller: widget._dto.openingTimeController,
                    hintText: 'Opening Time'.tr(context),
                  ),
                ),

                Text(
                  'to'.tr(context),
                  style: AppTextStyles.medium.copyWith(
                    color: AppColors.white,
                  ),
                ),

                Expanded(
                  child: AppTimePicker(
                    controller: widget._dto.closingTimeController,
                    hintText: 'Closing Time'.tr(context),
                  ),
                ),
              ],
            ),

            // Has Delivery
            AppCheckBoxField(
              controller: widget._dto.hasDeliveryController,
              label: 'Has Delivery'.tr(context),
            ),

            // Has Breakfast
            AppCheckBoxField(
              controller: widget._dto.hasBreakfastController,
              label: 'Has Breakfast'.tr(context),
            ),

            const Divider(color: AppColors.white, height: 12),
            Row(
              spacing: 16.w,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton.secondary(
                  text: 'Cancel'.tr(context),
                  onPressed: context.back,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                ),

                AppButton.primary(
                  text: 'Apply',
                  onPressed: () => context.back(widget._dto),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
