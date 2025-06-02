import 'package:app/core/routing/app_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension RoutingExtension on BuildContext {
  void to<TRoute extends AppRoute<T>, T>(TRoute route, T args) {
    kIsWeb ? go(route.getPath(args)) : push(route.getPath(args));
  }

  void off<TRoute extends AppRoute<T>, T>(TRoute route, T args) {
    kIsWeb
        ? go(route.getPath(args))
        : pushReplacement(route.getPath(args));
  }

  void offAll<TRoute extends AppRoute<T>, T>(TRoute route, T args) {
    go(route.getPath(args));
  }

  void toWith<TResult, TRoute extends AppRoute<T>, T>(
    TRoute route,
    T args, {
    required void Function(TResult result) onResult,
    void Function()? onError,
  }) async {
    final result = await push<TResult>(route.getPath(args));

    result != null ? onResult(result) : onError?.call();
  }

  void back<T>([T? result]) => Navigator.of(this).pop(result);

  void refresh() => GoRouter.of(
    this,
  ).pushReplacement(GoRouter.of(this).state.matchedLocation);
}
