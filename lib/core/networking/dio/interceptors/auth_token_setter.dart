part of 'dio_interceptors.dart';

class _AuthTokenInterceptor extends InterceptorsWrapper {
  final authCacheHelper = locator<AuthCache>();
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final accessToken = authCacheHelper.accessToken;

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    super.onRequest(options, handler);
  }

  _AuthTokenInterceptor._();
}
