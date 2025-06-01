class AppNavigator {
  final String _path;
  final Map<String, String> pathParams;
  final Map<String, String> queryParams;

  AppNavigator(
    String path, {
    this.pathParams = const {},
    this.queryParams = const {},
  }) : _path = path;

  String get path =>
      _path.replaceAllMapped(
        RegExp(r':(\w+)'),
        (match) => pathParams[match.group(1)!] ?? '',
      ) +
      (queryParams.isNotEmpty
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '');
}
