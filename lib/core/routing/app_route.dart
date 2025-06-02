import 'package:go_router/go_router.dart';

abstract class AppRoute<TParams> {
  final String _path;
  // final Map<String, String> pathParams;
  // final Map<String, String> queryParams;

  const AppRoute(String path) : _path = path;

  GoRoute get route;

  String getPath(TParams params) {
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

  Map<String, String> toPathParams(TParams params) => {};

  Map<String, String> toQueryParams(TParams params) => {};
}
