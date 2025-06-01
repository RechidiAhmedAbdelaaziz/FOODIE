import 'package:go_router/go_router.dart';

abstract class AppRoute<TParams> {
  final String _path;
  final Map<String, String> pathParams;
  final Map<String, String> queryParams;

  const AppRoute(
    String path, {
    this.pathParams = const {},
    this.queryParams = const {},
  }) : _path = path;

  GoRoute get route;

  String get path =>
      _path.replaceAllMapped(
        RegExp(r':(\w+)'),
        (match) => pathParams[match.group(1)!] ?? '',
      ) +
      (queryParams.isNotEmpty
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '');
}
