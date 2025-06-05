abstract class RouteParams {
  final Map<String, dynamic> pathParams;
  final Map<String, dynamic> queryParams;

  RouteParams({
    this.pathParams = const {},
    this.queryParams = const {},
  });

  String getPath(String path) {
    return path.replaceAllMapped(
          RegExp(r':(\w+)'),
          (match) => pathParams[match.group(1)!]?.toString() ?? '',
        ) +
        (queryParams.isNotEmpty
            ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
            : '');
  }
}
