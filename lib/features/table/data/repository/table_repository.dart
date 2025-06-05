import 'package:app/core/di/locator.dart';
import 'package:app/core/networking/network_repository.dart';
import 'package:app/core/shared/models/pagination_result.dart';
import 'package:app/features/table/data/dto/table_dto.dart';
import 'package:app/features/table/data/model/table_model.dart';
import 'package:injectable/injectable.dart';

import '../source/table_api.dart';

@lazySingleton
class TableRepo extends NetworkRepository {
  final _tableApi = locator<TableApi>();

  RepoListResult<TableModel> getTables() async {
    return tryApiCall(
      apiCall: () async => _tableApi.getTables(),
      onResult: (response) => PaginationResult.fromResponse(
        response: response,
        fromJson: TableModel.fromJson,
      ),
    );
  }

  RepoResult<TableModel> getTableById(String id) async {
    return tryApiCall(
      apiCall: () async => _tableApi.getTableById(id),
      onResult: (response) => TableModel.fromJson(response.data),
    );
  }

  RepoResult<TableModel> createTable(TableDTO dto) async {
    return tryApiCall(
      apiCall: () async => _tableApi.createTable(dto.toMap()),
      onResult: (response) => TableModel.fromJson(response.data),
    );
  }

  RepoResult<TableModel> updateTable(TableDTO dto) async {
    return tryApiCall(
      apiCall: () async => _tableApi.updateTable(dto.id, dto.toMap()),
      onResult: (response) => TableModel.fromJson(response.data),
    );
  }

  RepoResult<void> deleteTable(String id) async {
    return tryApiCall(
      apiCall: () async => _tableApi.deleteTable(id),
      onResult: (response) {},
    );
  }
}
