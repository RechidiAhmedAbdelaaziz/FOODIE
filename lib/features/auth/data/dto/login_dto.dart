import 'package:app/core/extensions/map_extension.dart';
import 'package:app/core/flavors/flavors.dart';
import 'package:app/core/shared/dto/form_dto.dart';
import 'package:app/core/shared/editioncontollers/boolean_editigcontroller.dart';
import 'package:flutter/widgets.dart';

class LoginDTO with FormDTO {
  final TextEditingController emailController =
      TextEditingController();
  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController nameController =
      TextEditingController();

  final BooleanEditingController loginWithEmailController =
      BooleanEditingController(false);

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    nameController.dispose();
  }

  String get login => loginWithEmailController.value
      ? emailController.text
      : phoneController.text;

  @override
  Map<String, dynamic> toMap() {
    return {
      // Send only one
      if (loginWithEmailController.value)
        'login': emailController.text,

      if (!loginWithEmailController.value)
        'login': phoneController.text,

      'role': F.appFlavor.role,
      'name': nameController.text,
    }.withoutNullsOrEmpty();
  }
}
