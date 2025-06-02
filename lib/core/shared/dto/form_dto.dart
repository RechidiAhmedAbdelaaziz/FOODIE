// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

mixin FormDto {
  final formKey = GlobalKey<FormState>();

  bool get isValid => formKey.currentState?.validate() ?? false;

  void dispose();

  Map<String, dynamic> toMap();
}

mixin AsyncFormDto {
  final formKey = GlobalKey<FormState>();

  bool get isValid => formKey.currentState?.validate() ?? false;

  void dispose();

  Future<Map<String, dynamic>> toMap();
}
