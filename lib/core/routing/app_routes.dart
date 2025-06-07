// ignore_for_file: unused_field, unused_element_parameter

part of 'router.dart';

enum AppRoutes<T extends RouteParams?> {
  login('/login', isGuarded: false),
  home('/home'),

  history('/history'),

  tables('/table'),

  createFood('/food-form'),
  updateFood<UpdateFoodFormParams>('/food-form/:id'),

  foodMenu('/food-menu'),

  staffs('/staff');

  final String path;
  final bool isGuarded;
  const AppRoutes(this.path, {this.isGuarded = true});
}
