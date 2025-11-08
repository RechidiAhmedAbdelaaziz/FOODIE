import 'package:app/core/extensions/list_extenstion.dart';
import 'package:app/core/extensions/popup_extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/routing_extension.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/food/data/model/food_model.dart';
import 'package:app/features/order/data/dto/create_order_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class FoodOrderCard extends StatelessWidget {
  final FoodModel food;
  final CreateOrderDTO dto;
  final bool canOrder;
  const FoodOrderCard(
    this.food,
    this.dto, {
    super.key,
    this.canOrder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border(
          bottom: BorderSide(color: AppColors.green, width: 1.w),
          top: BorderSide(color: AppColors.green, width: 1.w),
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.w,
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              image: DecorationImage(
                image: NetworkImage(food.image ?? ''),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 4.h,
              children: [
                Row(
                  spacing: 8.w,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // food name and description
                    Expanded(
                      child: SizedBox(
                        height: 100.h,
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.large.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                food.description ?? '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.small.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${food.price ?? 0} ',
                              style: AppTextStyles.h4.copyWith(
                                color: AppColors.greenLight,
                              ),
                            ),
                            TextSpan(
                              text: 'DA',
                              style: AppTextStyles.small.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (canOrder)
                      InkWell(
                        onTap: () => context.dialogWith<OrderMenuDTO>(
                          child: _FoodAddForm(food),
                          onResult: dto.menuController.addValue,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.greenLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Symbols.add,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodAddForm extends StatefulWidget {
  final FoodModel food;

  const _FoodAddForm(this.food);

  @override
  State<_FoodAddForm> createState() => _FoodAddFormState();
}

class _FoodAddFormState extends State<_FoodAddForm> {
  final List<AddOnsModel> addOns = [];
  int price = 0;
  int quantity = 1;

  @override
  void initState() {
    price = widget.food.price ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 650.h),
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 12.h),
      margin: EdgeInsets.symmetric(horizontal: 8.w),

      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.greenLight, width: 1.w),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        spacing: 12.h,
        children: [
          Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.food.image ?? ''),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24.r),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 12.h,
                  children: [
                    //name and description
                    Text(
                      widget.food.name ?? '',
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      widget.food.description ?? '',
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.white,
                      ),
                    ),

                    // quantity selector
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Symbols.remove,
                                color: AppColors.white,
                              ),
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() {
                                    quantity--;
                                    price = widget.food.totalPrice(
                                      addOns,
                                      quantity,
                                    );
                                  });
                                }
                              },
                            ),
                            Text(
                              '$quantity',
                              style: AppTextStyles.medium.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Symbols.add,
                                color: AppColors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                  price = widget.food.totalPrice(
                                    addOns,
                                    quantity,
                                  );
                                });
                              },
                            ),
                          ],
                        ),

                        Text(
                          '$price DA',
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.greenLight,
                          ),
                        ),
                      ],
                    ),

                    //addons
                    if (widget.food.addOns != null &&
                        widget.food.addOns!.isNotEmpty)
                      Column(
                        children: [
                          Text(
                            'Add Ons'.tr(context),
                            style: AppTextStyles.large.copyWith(
                              color: AppColors.greenLight,
                            ),
                          ),
                          ...widget.food.addOns!.map((addOn) {
                            return Row(
                              children: [
                                Checkbox(
                                  activeColor: AppColors.greenLight,
                                  checkColor: AppColors.black,

                                  value: addOns.contains(addOn),
                                  onChanged: (value) => setState(() {
                                    value == true
                                        ? addOns.addUnique(addOn)
                                        : addOns.remove(addOn);

                                    price = widget.food.totalPrice(
                                      addOns,
                                      quantity,
                                    );
                                  }),
                                ),
                                Expanded(
                                  child: Text(
                                    addOn.name ?? '',
                                    style: AppTextStyles.normal
                                        .copyWith(
                                          color: AppColors.white,
                                        ),
                                  ),
                                ),

                                Text(
                                  '+${addOn.price ?? 0} DA',
                                  style: AppTextStyles.medium
                                      .copyWith(
                                        color: AppColors.white,
                                      ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              spacing: 24.w,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton.secondary(
                  text: 'Cancel',
                  onPressed: () => context.back(),
                ),

                AppButton.primary(
                  text: 'Add to Order',
                  onPressed: () => context.back(
                    OrderMenuDTO()
                      ..addOnsController.setList(addOns)
                      ..foodController.setValue(widget.food)
                      ..quantityController.setValue(quantity),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
