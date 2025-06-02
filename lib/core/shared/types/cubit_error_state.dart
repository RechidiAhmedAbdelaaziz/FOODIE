import 'package:flutter/widgets.dart';

mixin CubitErrorHandling {
  String? get error;

  void onError(ValueChanged<String> callback) {
    if (error != null) {
      callback(error!);
    }
  }
}
