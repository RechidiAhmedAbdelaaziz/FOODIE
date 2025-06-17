// ignore_for_file: library_private_types_in_public_api

part of 'orders_cubit.dart';

enum _OrdersStatus { initial, loading, loaded, error }

class OrdersState with CubitErrorHandling {
  final List<OrderModel> _orders;
  final _OrdersStatus _status;
  final String? _errorMessage;

  const OrdersState({
    List<OrderModel> orders = const [],
    _OrdersStatus status = _OrdersStatus.initial,
    String? errorMessage,
  }) : _orders = orders,
       _status = status,
       _errorMessage = errorMessage;

  @override
  String? get error => _errorMessage;

  bool get isLoading => _status == _OrdersStatus.loading;

  OrdersState _copyWith({
    List<OrderModel>? orders,
    _OrdersStatus? status,
    String? errorMessage,
  }) {
    return OrdersState(
      orders: orders ?? _orders,
      status: status ?? _status,
      errorMessage: errorMessage,
    );
  }

  OrdersState _loading() => _copyWith(status: _OrdersStatus.loading);

  OrdersState _loaded(List<OrderModel> orders) =>
      _copyWith(status: _OrdersStatus.loaded, orders: orders);

  OrdersState _add(OrderModel order) => _NewOrdersState(order, this);

  OrdersState _update(OrderModel order) => _copyWith(
    status: _OrdersStatus.loaded,
    orders: _orders.withReplace(order),
  );

  OrdersState _remove(OrderModel order) => _copyWith(
    status: _OrdersStatus.loaded,
    orders: _orders.without(order),
  );

  OrdersState _error(String message) =>
      _copyWith(status: _OrdersStatus.error, errorMessage: message);

  void onAddOrder(ValueChanged<OrderModel> onAdd) {}
}

class _NewOrdersState extends OrdersState {
  final OrderModel _newOrder;

  _NewOrdersState(this._newOrder, OrdersState state)
    : super(
        orders: state._orders.withUnique(_newOrder),
        status: _OrdersStatus.loaded,
        errorMessage: state._errorMessage,
      );

  @override
  void onAddOrder(ValueChanged<OrderModel> onAdd) => onAdd(_newOrder);
}
