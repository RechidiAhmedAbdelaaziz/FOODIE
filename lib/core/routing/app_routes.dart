// ignore_for_file: unused_field, unused_element_parameter

part of 'router.dart';

enum AppRoutes<T extends RouteParams?> {
  login<Null>('/login', isGuarded: false),
  home<Null>('/home'),

  history<Null>('/history'),

  tables<Null>('/table'),

  createFood<Null>('/food-form'),
  updateFood<UpdateFoodFormParams>('/food-form/:id'),

  foodMenu<Null>('/food-menu'),

  staffs<Null>('/staff'),

  orders<Null>('/orders'),

  restaurants<RestaurantFilterParams>('/restaurants'),
  updateRestaurant<Null>('/restaurant-form');

  final String path;
  final bool isGuarded;
  const AppRoutes(this.path, {this.isGuarded = true});
}
