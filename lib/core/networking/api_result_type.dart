import 'package:app/core/networking/api_response_model.dart';

abstract class ApiResult<T> {
  factory ApiResult.success(T data) = _Success<T>;
  factory ApiResult.error(ErrorApiResponse errorHandler) =
      _Failure<T>;

  ApiResult();

  //when function
  R when<R>({
    required R Function(T data) success,
    required R Function(ErrorApiResponse errorHandler) error,
  }) {
    final v = this;
    if (v is _Success) {
      return success((v as _Success).data);
    } else if (v is _Failure) {
      return error((v as _Failure).errorHandler);
    } else {
      throw 'error';
    }
  }
}

class _Success<T> extends ApiResult<T> {
  _Success(this.data) : super();

  final T data;
}

class _Failure<T> extends ApiResult<T> {
  _Failure(this.errorHandler) : super();

  final ErrorApiResponse errorHandler;
}
