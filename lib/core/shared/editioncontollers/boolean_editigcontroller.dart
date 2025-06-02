import 'package:flutter/foundation.dart';

class BooleanEditingController extends ValueNotifier<bool> {
  BooleanEditingController([super._value = false]);

  void setValue(bool value) => this.value = value;

  void toggle() => value = !value;
}
