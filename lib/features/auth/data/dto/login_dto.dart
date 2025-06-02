import 'package:app/core/shared/dto/form_dto.dart';
import 'package:flutter/widgets.dart';

class LoginDTO with FormDTO {
  final TextEditingController emailController =
      TextEditingController();
  final TextEditingController phoneController =
      TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
    };
  }
}
