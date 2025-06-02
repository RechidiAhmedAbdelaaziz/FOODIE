import 'package:app/core/networking/dio/interceptors/dio_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio provideDio() {
    final dio = Dio();

    final timeOut = const Duration(seconds: 30);
    dio.options
      ..connectTimeout = timeOut
      ..receiveTimeout = timeOut
      ..baseUrl = FlavorConfig.instance.variables["baseUrl"] ?? ''
      ..headers = {'Accept': 'application/json'};

    if (kDebugMode) dio.addLogger();

    dio.addErrorInterceptor();
    dio.addAuthTokenInterceptor();

    return dio;
  }
}
