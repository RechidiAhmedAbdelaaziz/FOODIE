import 'package:app/core/di/locator.dart';
import 'package:app/core/networking/network_repository.dart';
import 'package:app/core/shared/models/pagination_result.dart';
import 'package:app/features/order/data/model/order_model.dart';
import 'package:injectable/injectable.dart';

import '../source/order_api.dart';

@lazySingleton
class OrderRepo extends NetworkRepository {
  final _orderApi = locator<OrderApi>();

  RepoListResult<OrderModel> getOrders() => tryApiCall(
    apiCall: () async => _orderApi.getOrders(),
    onResult: (response) => PaginationResult.fromResponse(
      response: response,
      fromJson: OrderModel.fromJson,
    ),
  );
}
