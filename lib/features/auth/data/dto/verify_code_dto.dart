import 'package:app/core/shared/dto/form_dto.dart';
import 'package:flutter/material.dart';

class VerifyCodeDTO with FormDTO {
  final String login;
  final TextEditingController codeController;

  VerifyCodeDTO({required this.login})
    : codeController = TextEditingController();

  @override
  void dispose() => codeController.dispose();

  @override
  Map<String, dynamic> toMap() => {
    'login': login,
    'otp': codeController.text,
  };
}
