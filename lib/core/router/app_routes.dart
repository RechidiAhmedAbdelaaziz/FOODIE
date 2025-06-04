// ignore_for_file: unused_field, unused_element_parameter

part of 'router.dart';

enum AppRoutes<T extends RouteParams?> {
  login('/login', isGuarded: false),
  home('/home');

  final String path;
  final bool isGuarded;
  const AppRoutes(this.path, {this.isGuarded = true});
}
