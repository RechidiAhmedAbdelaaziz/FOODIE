part of 'dio_interceptors.dart';

class DioErrorInterceptor extends InterceptorsWrapper {
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    //TODO implement the error interceptor
    // if (err.response?.statusCode == 401) {
    //   await locator<AuthCubit>().refreshToken();

    //   return handler.resolve(
    //     await locator<Dio>().fetch(err.requestOptions),
    //   );
    // }

    // return handler.next(err);
    return super.onError(err, handler);
  }

  DioErrorInterceptor._();
}
