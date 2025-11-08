import 'package:app/core/di/locator.dart';
import 'package:app/core/shared/types/cubit_error_state.dart';
import 'package:app/features/order/data/dto/create_order_dto.dart';
import 'package:app/features/order/data/model/order_model.dart';
import 'package:app/features/order/data/repository/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final _repo = locator<OrderRepo>();
  final CreateOrderDTO _createOrderDTO;

  OrderCubit(this._createOrderDTO) : super(OrderState.initial());

  CreateOrderDTO get dto => _createOrderDTO;

  void saveOrder() async {
    if (state.isLoading) return;

    emit(state._loading());

    final result = await _repo.createOrder(_createOrderDTO);

    result.when(
      success: (order) => emit(state._success(order)),
      error: (error) => emit(state._error(error.message)),
    );
  }
}
