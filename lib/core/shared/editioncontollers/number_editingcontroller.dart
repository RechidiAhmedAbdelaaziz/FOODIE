import 'package:flutter/foundation.dart';

class IntEditingcontroller extends ValueNotifier<int> {
  IntEditingcontroller([super._value = 0]);

  void setValue(int value) => this.value = value;

  void add(int value) => this.value += value;
  void subtract(int value) => this.value -= value;

  void clear() => value = 0;
}

class DoubleEditingcontroller extends ValueNotifier<double> {
  DoubleEditingcontroller([super._value = 0.0]);

  void setValue(double value) => this.value = value;

  void add(double value) => this.value += value;
  void subtract(double value) => this.value -= value;

  void clear() => value = 0.0;
}
