import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_route.dart';
import 'router.dart';

extension RoutingExtension on BuildContext {
  String _getPath(AppRoutes route, RouteParams? params) {
    return params == null ? route.path : params.getPath(route.path);
  }

  void to<D extends RouteParams?, T extends AppRoutes<D>, TResutl>(
    T route,
    D params,
  ) => push<TResutl>(_getPath(route, params));

  void
  toWith<D extends RouteParams?, T extends AppRoutes<D>, TResutl>(
    T route,
    D params, {
    required ValueChanged<TResutl> onResult,
    VoidCallback? onError,
  }) async {
    final result = await push<TResutl>(_getPath(route, params));
    result != null ? onResult(result) : onError?.call();
  }

  void off<D extends RouteParams?, T extends AppRoutes<D>>(
    T route,
    D params,
  ) {
    pushReplacement(_getPath(route, params));
  }

  void offAll<D extends RouteParams?, T extends AppRoutes<D>>(
    T route,
    D params,
  ) {
    go(_getPath(route, params));
  }

  void back<T>([T? result]) => Navigator.of(this).pop(result);

  void refresh() => GoRouter.of(
    this,
  ).pushReplacement(GoRouter.of(this).state.matchedLocation);
}
