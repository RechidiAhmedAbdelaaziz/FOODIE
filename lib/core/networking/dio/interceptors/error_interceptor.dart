part of 'dio_interceptors.dart';

class DioErrorInterceptor extends InterceptorsWrapper {
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 &&
        await locator<AuthCubit>().refreshToken()) {
      return handler.resolve(
        await locator<Dio>().fetch(err.requestOptions),
      );
    }

    return handler.next(err);
  }

  DioErrorInterceptor._();
}
