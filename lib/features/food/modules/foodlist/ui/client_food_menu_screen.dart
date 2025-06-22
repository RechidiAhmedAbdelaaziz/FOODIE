import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/bottom_extension.dart';
import 'package:app/core/extensions/snackbar.extension.dart';
import 'package:app/core/localization/localization_extension.dart';
import 'package:app/core/routing/app_route.dart';
import 'package:app/core/routing/router.dart';
import 'package:app/core/services/sounds/sound_service.dart';
import 'package:app/core/shared/editioncontollers/generic_editingcontroller.dart';
import 'package:app/core/shared/widgets/app_button.dart';
import 'package:app/core/shared/widgets/app_logo.dart';
import 'package:app/core/themes/colors.dart';
import 'package:app/core/themes/dimensions.dart';
import 'package:app/core/themes/font_styles.dart';
import 'package:app/features/food/data/dto/food_filter_dto.dart';
import 'package:app/features/food/data/model/food_model.dart';
import 'package:app/features/food/modules/foodlist/logic/food_list_cubit.dart';
import 'package:app/features/order/data/dto/create_order_dto.dart';
import 'package:app/features/order/modules/order/logic/order_cubit.dart';
import 'package:app/features/order/modules/order/ui/confirm_order_view.dart';
import 'package:app/features/order/modules/order/ui/food_order_card.dart';
import 'package:app/features/restaurant/data/model/restaurant_model.dart';
import 'package:app/features/restaurant/data/repository/restaurant_repository.dart';
import 'package:app/features/table/data/model/table_model.dart';
import 'package:app/features/table/data/repository/table_repository.dart';
import 'package:app/features/table/modules/tableheader/table_header.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RestaurantMenuParams extends RouteParams {
  final String tableId;

  RestaurantMenuParams(this.tableId)
    : super(pathParams: {'id': tableId});
}

class TableFoodMenuScreen extends StatefulWidget {
  final String? tableId;
  final String? restaurantId;
  const TableFoodMenuScreen({
    super.key,
    this.tableId,
    this.restaurantId,
  });

  static List<RouteBase> get routes => [
    GoRoute(
      path: AppRoutes.tableFoodMenu.path,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FoodListCubit(
              FoodFilterDTO(
                fields: FoodModelFields.client.value,
                limit: 60,
              ),
            ),
          ),
          BlocProvider(
            create: (context) => OrderCubit(CreateOrderDTO()),
          ),
        ],
        child: TableFoodMenuScreen(
          tableId: state.pathParameters['id'],
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.restaurantFoodMenu.path,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FoodListCubit(
              FoodFilterDTO(
                fields: FoodModelFields.client.value,
                limit: 60,
              ),
            ),
          ),
          BlocProvider(
            create: (context) => OrderCubit(CreateOrderDTO()),
          ),
        ],
        child: TableFoodMenuScreen(
          restaurantId: state.pathParameters['id'],
        ),
      ),
    ),
  ];

  @override
  State<TableFoodMenuScreen> createState() =>
      _TableFoodMenuScreenState();
}

class _TableFoodMenuScreenState extends State<TableFoodMenuScreen> {
  TableModel? _table;
  RestaurantModel? _restaurant;
  bool? _isLoading = false;
  late final bool canOrder;
  final categoryController = EditingController<String>();

  @override
  void initState() {
    if (widget.restaurantId != null) {
      setState(() => _isLoading = true);
      locator<RestaurantRepo>()
          .getRestaurantById(widget.restaurantId!)
          .then((result) {
            result.when(
              success: (restaurant) {
                _restaurant = restaurant;

                canOrder = restaurant.hasDelivery ?? false;

                context.read<FoodListCubit>().filter.setId(
                  restaurant.id!,
                );
                context.read<FoodListCubit>().fetchFoods();

                context
                    .read<OrderCubit>()
                    .dto
                    .restaurantController
                    .setValue(restaurant);

                setState(() => _isLoading = false);
              },
              error: (error) =>
                  context.showErrorSnackbar(error.message),
            );
          });
    } else if (widget.tableId != null) {
      setState(() => _isLoading = true);

      locator<TableRepo>().getTableById(widget.tableId!).then((
        result,
      ) {
        result.when(
          success: (table) {
            _table = table;
            context.read<FoodListCubit>().filter.setId(
              table.restaurant!.id!,
            );
            context.read<FoodListCubit>().fetchFoods();

            context.read<OrderCubit>().dto.tableController.setValue(
              table,
            );
            context
                .read<OrderCubit>()
                .dto
                .restaurantController
                .setValue(table.restaurant!);

            canOrder = true;
            setState(() => _isLoading = false);
          },
          error: (_) => setState(() => _isLoading = false),
        );
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FoodListCubit, FoodListState>(
          listener: (context, state) {
            state.onError(context.showErrorSnackbar);

            if (categoryController.value == null &&
                context.read<FoodListCubit>().categories.isNotEmpty) {
              categoryController.initValue(
                context.read<FoodListCubit>().categories.first,
              );
            }
          },
        ),
        BlocListener<OrderCubit, OrderState>(
          listener: (context, state) {
            state.onError(context.showErrorSnackbar);

            // setState(() => _isLoading = state.isLoading);

            state.onSuccess((order) {
              // empty the order dto
              context.read<OrderCubit>().dto.menuController.clear();

              locator<SoundService>().playSound(
                Assets.sounds.panClose,
              );

              context.showSuccessSnackbar(
                'Order created successfully'.tr(context),
              );
            });
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: AppLogo()),
        body: _isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.green,
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    heightSpace(8),
                    TableHeader(_table, _restaurant),
                    heightSpace(12),

                    Builder(
                      builder: (context) {
                        final cubit = context.read<FoodListCubit>();
                        return ValueListenableBuilder(
                          valueListenable: categoryController,
                          builder: (context, selected, child) {
                            return Column(
                              spacing: 12.h,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    spacing: 12.w,
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: cubit.categories
                                        .map(
                                          (category) => InkWell(
                                            focusColor:
                                                Colors.transparent,
                                            highlightColor:
                                                Colors.transparent,
                                            hoverColor:
                                                Colors.transparent,
                                            splashColor:
                                                Colors.transparent,
                                            overlayColor:
                                                WidgetStateProperty.all(
                                                  Colors.transparent,
                                                ),
                                            onTap: () =>
                                                categoryController
                                                    .setValue(
                                                      category,
                                                    ),
                                            child:
                                                _buildCatogoryButton(
                                                  context,
                                                  category,
                                                  selected ==
                                                      category,
                                                ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),

                                SingleChildScrollView(
                                  child: Column(
                                    spacing: 8.h,
                                    children: cubit.foods
                                        .where(
                                          (food) =>
                                              food.category ==
                                                  selected ||
                                              selected == null,
                                        )
                                        .map(
                                          (food) => FoodOrderCard(
                                            food,
                                            context
                                                .read<OrderCubit>()
                                                .dto,
                                            canOrder: canOrder,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: context
              .read<OrderCubit>()
              .dto
              .menuController,
          builder: (context, selectedFoods, child) {
            if (selectedFoods.isEmpty) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: EdgeInsets.all(8.r),
              child: AppButton.primary(
                text:
                    '${'Confirm'.tr(context)} (${selectedFoods.length})',
                onPressed: () {
                  context.bottomSheetWith<bool>(
                    child: ConfirmOrderView(
                      context.read<OrderCubit>().dto.menuController,
                    ),
                    onResult: (_) {
                      context.read<OrderCubit>().saveOrder();
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // category button is white when not selected, and AppColors.green when selected with point
  Widget _buildCatogoryButton(
    BuildContext context,
    String category,
    bool isSelected,
  ) {
    return Padding(
      padding: EdgeInsets.all(4.r),
      child: Column(
        spacing: 2.h,
        children: [
          Text(
            category.tr(context),
            style: AppTextStyles.large.copyWith(
              color: isSelected ? AppColors.green : AppColors.white,
            ),
          ),
          if (isSelected)
            Container(
              width: 4.r,
              height: 4.r,
              decoration: BoxDecoration(
                color: AppColors.green,
                // borderRadius: BorderRadius.circular(4.r),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
