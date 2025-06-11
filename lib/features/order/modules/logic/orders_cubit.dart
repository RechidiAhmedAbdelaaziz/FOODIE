import 'package:app/core/di/locator.dart';
import 'package:app/core/extensions/list_extenstion.dart';
import 'package:app/core/shared/types/cubit_error_state.dart';
import 'package:app/features/order/data/model/order_model.dart';
import 'package:app/features/order/data/repository/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final _repo = locator<OrderRepo>();

  OrdersCubit() : super(OrdersState());

  List<OrderModel> get orders => state._orders;

  void fetchOrders() async {
    emit(state._loading());

    final result = await _repo.getOrders();

    result.when(
      success: (result) {
        final orders = result.data;

        emit(state._loaded(orders));

        _initSocketListeners();
      },
      error: (error) => emit(state._error(error.message)),
    );
  }

  // init listen to socket
  void _initSocketListeners() {
    _repo.onNewOrder((order) => emit(state._add(order)));
    _repo.onOrderUpdated((order) => emit(state._update(order)));
    _repo.onOrderDeleted((order) => emit(state._remove(order)));
  }

  @override
  Future<void> close() {
    _repo.disconnect();

    return super.close();
  }
}
