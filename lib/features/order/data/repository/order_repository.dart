import 'package:app/core/di/locator.dart';
import 'package:app/core/networking/network_repository.dart';
import 'package:app/core/services/socketio/socket_io_service.dart';
import 'package:app/core/shared/models/pagination_result.dart';
import 'package:app/features/order/data/dto/create_order_dto.dart';
import 'package:app/features/order/data/dto/update_order_dto.dart';
import 'package:app/features/order/data/model/order_model.dart';
import 'package:injectable/injectable.dart';

import '../source/order_api.dart';

@lazySingleton
class OrderRepo extends NetworkRepository {
  final _orderApi = locator<OrderApi>();
  final _socket = locator<SocketIoService>();

  RepoListResult<OrderModel> getOrders() => tryApiCall(
    apiCall: () async => _orderApi.getOrders(),
    onResult: (response) => PaginationResult.fromResponse(
      response: response,
      fromJson: OrderModel.fromJson,
    ),
  );

  RepoResult<OrderModel> createOrder(CreateOrderDTO dto) =>
      tryApiCall(
        apiCall: () async => _orderApi.createOrder(dto.toMap()),
        onResult: (response) => OrderModel.fromJson(response.data),
      );

  RepoResult<OrderModel> updateOrder(UpdateOrderDTO dto) =>
      tryApiCall(
        apiCall: () async =>
            _orderApi.updateOrder(dto.id, dto.toMap()),
        onResult: (response) => OrderModel.fromJson(response.data),
      );

  RepoResult<void> deleteOrder(String orderId) => tryApiCall(
    apiCall: () async => _orderApi.deleteOrder(orderId),
    onResult: (_) {},
  );

  // * SOCKET METHODS

  void onNewOrder(Function(OrderModel order) callback) =>
      _socket.onData(
        'NEW_ORDER',
        (data) => callback(OrderModel.fromJson(data.data)),
      );

  void onOrderUpdated(Function(OrderModel order) callback) =>
      _socket.onData(
        'ORDER_UPDATED',
        (data) => callback(OrderModel.fromJson(data.data)),
      );

  void onOrderDeleted(Function(OrderModel order) callback) =>
      _socket.onData(
        'ORDER_DELETED',
        (data) => callback(OrderModel.fromJson(data.data)),
      );

  void disconnect() => _socket.disconnect();
}
