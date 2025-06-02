import 'package:app/core/services/cache/cache_service.dart';
import 'package:app/features/auth/data/model/auth_tokens.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthCache {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  final CacheService _cacheService;

  const AuthCache(this._cacheService);

  Future<void> saveTokens(AuthTokens tokens) async {
    await Future.wait([
      _cacheService.setData(_accessTokenKey, tokens.accessToken),
      _cacheService.setSecuredString(
        _refreshTokenKey,
        tokens.refreshToken,
      ),
    ]);
  }

  String? get accessToken => _cacheService.getString(_accessTokenKey);
  Future<String?> get refreshToken async =>
      _cacheService.getSecuredString(_refreshTokenKey);

  void logOut() {
    _cacheService.removeData(_accessTokenKey);
    _cacheService.removeSecuredData(_refreshTokenKey);
  }
}
