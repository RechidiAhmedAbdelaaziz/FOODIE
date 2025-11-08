import 'package:app/core/extensions/map_extension.dart';
import 'package:app/core/shared/dto/form_dto.dart';
import 'package:app/features/order/data/model/order_model.dart';

class UpdateOrderDTO with FormDTO {
  final OrderModel _order;

  final bool? isDelivered;
  final bool? isPaid;

  UpdateOrderDTO(this._order, {this.isDelivered, this.isPaid});

  String get id => _order.id ?? '';

  @override
  Map<String, dynamic> toMap() {
    return {
      'isDelivered': isDelivered,
      'isPaid': isPaid,
    }.withoutNullsOrEmpty();
  }

  @override
  void dispose() {}
}
