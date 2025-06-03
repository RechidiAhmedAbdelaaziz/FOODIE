import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

abstract class AppRoute<TParams> {
  final String _path;

  AppRoute(
    String path, {
    required Widget Function(
      BuildContext context,
      GoRouterState state,
    )
    builder,
  }) : _path = path,
       route = GoRoute(path: path, builder: builder);

  final GoRoute route;

  String getPath(TParams params);
}

mixin RouteArgs<T> on AppRoute<T> {
  Map<String, String> toPathParams(T params);

  Map<String, String> toQueryParams(T params);

  //override the getPath method to use the params
  @override
  String getPath(params) {
    final pathParams = toPathParams(params);
    final queryParams = toQueryParams(params);

    return _path.replaceAllMapped(
          RegExp(r':(\w+)'),
          (match) => pathParams[match.group(1)!] ?? '',
        ) +
        (queryParams.isNotEmpty
            ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
            : '');
  }
}

mixin NoArgsRoute on AppRoute<Null> {
  @override
  String getPath([params]) => _path;
}
