part of 'dio_interceptors.dart';

class _AppDioLogger extends PrettyDioLogger {
  _AppDioLogger._()
      : super(
          requestBody: true,
          requestHeader: true,
          responseHeader: true,
          responseBody: true,
        );

  static PrettyDioLogger get instance => _AppDioLogger._();
}
