import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension RoutingExtension on BuildContext {
  void pushWith<TResult>(
    String route, {
    required void Function(TResult result) onResult,
    void Function()? onError,
  }) async {
    final result = await push<TResult>(route);

    result != null ? onResult(result) : onError?.call();
  }

  void back<T>([T? result]) => Navigator.of(this).pop(result);

  void refresh() => GoRouter.of(
    this,
  ).pushReplacement(GoRouter.of(this).state.matchedLocation);
}
