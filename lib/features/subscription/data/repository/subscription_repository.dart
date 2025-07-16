import 'package:app/core/di/locator.dart';
import 'package:app/core/networking/network_repository.dart';
import 'package:app/features/subscription/data/dto/subscribe_dto.dart';
import 'package:injectable/injectable.dart';

import '../models/subscription_model.dart';
import '../source/subscription_api.dart';

@lazySingleton
class SubscriptionRepo extends NetworkRepository {
  final _subscriptionApi = locator<SubscriptionApi>();

  RepoResult<SubscriptionModel> getMySubscription() {
    return tryApiCall(
      apiCall: () => _subscriptionApi.getMySubscription(),
      onResult: (response) =>
          SubscriptionModel.fromJson(response.data),
    );
  }

  RepoResult<void> subscribe(SubscribeDto dto) {
    return tryApiCall(
      apiCall: () => _subscriptionApi.subscribeToPlan(dto.toMap()),
      onResult: (response) {},
    );
  }
}
