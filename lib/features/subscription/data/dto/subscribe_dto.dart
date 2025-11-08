import 'package:app/core/extensions/map_extension.dart';
import 'package:app/core/shared/dto/form_dto.dart';
import 'package:app/core/shared/editioncontollers/generic_editingcontroller.dart';

class SubscribeDto with FormDTO {
  final EditingController<DateTime> expirationDate;

  SubscribeDto() : expirationDate = EditingController<DateTime>();

  @override
  void dispose() {
    expirationDate.dispose();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'expirationDate': expirationDate.value?.toIso8601String(),
    }.withoutNullsOrEmpty();
  }
}
