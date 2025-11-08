import 'package:app/core/di/locator.dart';
import 'package:app/core/networking/network_repository.dart';
import 'package:app/core/shared/dto/pagination_dto.dart';
import 'package:app/core/shared/models/pagination_result.dart';
import 'package:injectable/injectable.dart';

import '../model/history_model.dart';
import '../source/history_api.dart';

@lazySingleton
class HistoryRepo extends NetworkRepository {
  final _historyApi = locator<HistoryApi>();

  RepoListResult<HistoryModel> getHistory({
    required PaginationDto pagination,
  }) => tryApiCall(
    apiCall: () async =>
        _historyApi.getHistory(queries: pagination.toMap()),
    onResult: (response) => PaginationResult.fromResponse(
      response: response,
      fromJson: HistoryModel.fromJson,
    ),
  );

  RepoResult<HistoryModel> getLastHistory() => tryApiCall(
    apiCall: _historyApi.getLastHistory,
    onResult: (response) => HistoryModel.fromJson(response.data),
  );
}
