import 'package:app/core/di/locator.dart';
import 'package:app/core/networking/network_repository.dart';
import 'package:app/core/shared/dto/pagination_dto.dart';
import 'package:app/core/shared/models/pagination_result.dart';
import 'package:app/features/staff/data/dto/create_staff_dto.dart';
import 'package:app/features/staff/data/dto/update_staff_dto.dart';
import 'package:app/features/staff/data/model/staff_model.dart';
import 'package:injectable/injectable.dart';

import '../source/staff_api.dart';

@lazySingleton
class StaffRepo extends NetworkRepository {
  final _staffApi = locator<StaffApi>();

  RepoListResult<StaffModel> getStaffs(
    PaginationDto pagination,
  ) async {
    return tryApiCall(
      apiCall: () async => _staffApi.getStaffs(pagination.toMap()),
      onResult: (response) => PaginationResult.fromResponse(
        response: response,
        fromJson: StaffModel.fromJson,
      ),
    );
  }

  RepoResult<StaffModel> getStaffById(String id) async {
    return tryApiCall(
      apiCall: () async => _staffApi.getStaffById(id),
      onResult: (response) => StaffModel.fromJson(response.data),
    );
  }

  RepoResult<StaffModel> createStaff(CreateStaffDTO dto) async {
    return tryApiCall(
      apiCall: () async => _staffApi.createStaff(dto.toMap()),
      onResult: (response) => StaffModel.fromJson(response.data),
    );
  }

  RepoResult<StaffModel> updateStaff(UpdateStaffDTO dto) async {
    return tryApiCall(
      apiCall: () async => _staffApi.updateStaff(dto.id, dto.toMap()),
      onResult: (response) => StaffModel.fromJson(response.data),
    );
  }

  RepoResult<void> deleteStaff(String id) async {
    return tryApiCall(
      apiCall: () async => _staffApi.deleteStaff(id),
      onResult: (response) {},
    );
  }
}
