import 'package:app/core/di/locator.dart';
import 'package:app/core/networking/network_repository.dart';
import 'package:app/core/shared/models/pagination_result.dart';
import 'package:app/features/banners/data/model/banner_model.dart';
import 'package:injectable/injectable.dart';

import '../source/banners_api.dart';

@lazySingleton
class BannersRepo extends NetworkRepository {
  final _bannersApi = locator<BannersApi>();

  RepoListResult<BannerModel> getBanners() => tryApiCall(
    apiCall: () async => _bannersApi.getBanners(),
    onResult: (response) => PaginationResult.fromResponse(
      response: response,
      fromJson: BannerModel.fromJson,
    ),
  );
}
