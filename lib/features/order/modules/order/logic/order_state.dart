part of 'order_cubit.dart';

class OrderState with CubitErrorHandling {
  final bool isLoading;
  final OrderModel? order;
  final String? errorMessage;

  OrderState({this.isLoading = false, this.order, this.errorMessage});

  factory OrderState.initial() => OrderState();

  OrderState _copyWith({
    bool? isLoading,
    OrderModel? order,
    String? errorMessage,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      order: order,
      errorMessage: errorMessage,
    );
  }

  @override
  String? get error => errorMessage;

  OrderState _loading() => _copyWith(isLoading: true);

  OrderState _success(OrderModel order) =>
      _copyWith(order: order, isLoading: false);

  OrderState _error(String message) =>
      _copyWith(errorMessage: message, isLoading: false);

  void onSuccess(ValueChanged<OrderModel> onSuccess) {
    if (order != null) onSuccess(order!);
  }
}
