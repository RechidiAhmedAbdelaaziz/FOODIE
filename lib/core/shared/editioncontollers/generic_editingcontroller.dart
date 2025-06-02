import 'package:flutter/material.dart';

class EditingController<T> extends ValueNotifier<T?> {
  EditingController([super._value]);

  void setValue(T value) => this.value = value;

  void initValue(T value) {
    if (this.value == null) {
      this.value = value;
    }
  }

  void clear() => value = null;
}
