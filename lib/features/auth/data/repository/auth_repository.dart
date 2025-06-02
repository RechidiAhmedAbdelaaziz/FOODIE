import 'package:app/core/di/locator.dart';
import 'package:app/core/networking/network_repository.dart';
import 'package:app/features/auth/data/dto/login_dto.dart';
import 'package:app/features/auth/data/model/auth_tokens.dart';
import 'package:injectable/injectable.dart';

import '../source/auth_api.dart';

@lazySingleton
class AuthRepo extends NetworkRepository {
  final _authApi = locator<AuthApi>();

  RepoResult<AuthTokens> login(LoginDTO dto) {
    return tryApiCall(
      apiCall: () async => _authApi.login(dto.toMap()),
      onResult: (response) => AuthTokens.fromJson(response.data),
    );
  }

  RepoResult<AuthTokens> refreshToken(String refreshToken) {
    return tryApiCall(
      apiCall: () async =>
          _authApi.refreshToken(refreshToken: refreshToken),
      onResult: (response) => AuthTokens.fromJson(response.data),
    );
  }
}
