import 'package:app/core/extensions/map_extension.dart';
import 'package:app/core/shared/dto/form_dto.dart';
import 'package:app/core/shared/editioncontollers/boolean_editigcontroller.dart';
import 'package:app/core/shared/editioncontollers/list_generic_editingcontroller.dart';
import 'package:app/features/staff/data/model/staff_model.dart';
import 'package:app/features/table/data/model/table_model.dart';
import 'package:flutter/widgets.dart';

class TableDTO with FormDTO {
  final TableModel? _table;

  final TextEditingController nameController;
  final ListEditingController<StaffModel> staffController;
  final BooleanEditingController forAllStaffController;

  TableDTO(this._table)
    : nameController = TextEditingController(text: _table?.name),
      staffController = ListEditingController<StaffModel>(
        _table?.staff,
      ),
      forAllStaffController = BooleanEditingController(
        _table?.forAllStaff ?? false,
      );

  String get id => _table!.id!;

  @override
  void dispose() {
    nameController.dispose();
    staffController.dispose();
    forAllStaffController.dispose();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      if (_table == null || _table.name != nameController.value.text)
        'name': nameController.value.text,

      if (!forAllStaffController.value &&
          (_table == null || _table.staff != staffController.value))
        'staff': staffController.value.map((e) => e.id!).toList(),

      if (_table == null ||
          _table.forAllStaff != forAllStaffController.value)
        'forAllStaff': forAllStaffController.value,
    }.withoutNullsOrEmpty();
  }
}
