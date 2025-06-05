import 'package:app/core/extensions/map_extension.dart';
import 'package:app/core/shared/dto/form_dto.dart';
import 'package:flutter/widgets.dart';

class CreateStaffDTO with FormDTO {
  final TextEditingController nameController;
  final TextEditingController loginController;

  CreateStaffDTO()
    : nameController = TextEditingController(),
      loginController = TextEditingController();

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': nameController.text,
      'login': loginController.text,
    }.withoutNullsOrEmpty();
  }

  @override
  void dispose() {
    nameController.dispose();
    loginController.dispose();
  }
}
