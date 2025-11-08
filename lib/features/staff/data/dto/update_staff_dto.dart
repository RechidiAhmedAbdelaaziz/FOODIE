import 'package:app/core/extensions/map_extension.dart';
import 'package:app/features/staff/data/dto/create_staff_dto.dart';
import 'package:app/features/staff/data/model/staff_model.dart';
import 'package:flutter/material.dart';

class UpdateStaffDTO extends CreateStaffDTO {
  final StaffModel _staff;

  final TextEditingController mountGottenController;

  UpdateStaffDTO(this._staff)
    : mountGottenController = TextEditingController(),
      super() {
    nameController.text = _staff.name ?? '';
    loginController.text = _staff.login ?? '';
  }

  String get id => _staff.id ?? '';

  @override
  void dispose() {
    mountGottenController.dispose();
    super.dispose();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      if (_staff.name != nameController.text)
        'name': nameController.text,

      if (_staff.login != loginController.text)
        'login': loginController.text,

      if (mountGottenController.text != '')
        'amount': int.tryParse(mountGottenController.text) ?? 0,
    }.withoutNullsOrEmpty();
  }
}
