// ignore_for_file: unused_field, unused_element_parameter

part of 'router.dart';

enum AppRoutes<T extends RouteParams?> {
  login<Null>('/login', isGuarded: false),
  verifyCode<VerifyCodeParams>('/verify-code', isGuarded: false),

  home<Null>('/home'),

  history<Null>('/history'),

  tables<Null>('/table'),

  createFood<Null>('/food-form'),
  updateFood<UpdateFoodFormParams>('/food-form/:id'),

  foodMenu<Null>('/food-menu'),
  foodPriceCalculator<Null>('/food-price-calculator'),
  tableFoodMenu<RestaurantMenuParams>('/table-food-menu/:id'),
  restaurantFoodMenu<RestaurantMenuParams>(
    '/restaurant-food-menu/:id',
  ),

  staffs<Null>('/staff'),

  orders<Null>('/orders'),
  tableOrders<Null>('/table-orders'),

  loginLoading<Null>('/login-loading'),

  restaurants<RestaurantFilterParams>('/restaurants'),
  updateRestaurant<Null>('/restaurant-form');

  final String path;
  final bool isGuarded;
  const AppRoutes(this.path, {this.isGuarded = true});
}

class LoadingScreen extends StatelessWidget {
  // static RouteBase get route => GoRoute(
  //   path: AppRoutes.loginLoading.path,
  //   builder: (context, state) {
  //     return LoadingScreen(
  //       onRedirect: () {
  //         context.go(AppRoutes.login.path);
  //       },
  //     );
  //   },
  // );

  final ValueChanged<BuildContext> onRedirect;
  const LoadingScreen({super.key, required this.onRedirect});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      // ignore: use_build_context_synchronously
      () => onRedirect(context),
    );
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: AppColors.green),
      ),
    );
  }
}
