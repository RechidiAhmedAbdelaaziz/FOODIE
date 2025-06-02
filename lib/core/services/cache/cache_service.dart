import 'dart:convert';

import 'package:app/core/di/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class CacheService {
  final SharedPreferences _sharedPreferences =
      locator<SharedPreferences>();
  final FlutterSecureStorage _flutterSecureStorage =
      locator<FlutterSecureStorage>();

  /// Removes a value from SharedPreferences with given [key].
  void removeData(String key) async {
    debugPrint(
      'SharedPrefHelper : data with key : $key has been removed',
    );

    await _sharedPreferences.remove(key);
  }

  /// Removes all keys and values in the SharedPreferences
  void clearAllData() async {
    debugPrint('SharedPrefHelper : all data has been cleared');

    await _sharedPreferences.clear();
  }

  /// Saves a [value] with a [key] in the _sharedPreferences.
  Future<void> setData(String key, value) async {
    debugPrint(
      "SharedPrefHelper : setData with key : $key and value : $value",
    );
    switch (value.runtimeType) {
      case const (String):
        await _sharedPreferences.setString(key, value);
        break;
      case const (int):
        await _sharedPreferences.setInt(key, value);
        break;
      case const (bool):
        await _sharedPreferences.setBool(key, value);
        break;
      case const (double):
        await _sharedPreferences.setDouble(key, value);
        break;
      default:
        return;
    }
  }

  /// Gets a bool value from SharedPreferences with given [key].
  bool getBool(String key) {
    debugPrint('SharedPrefHelper : getBool with key : $key');

    return _sharedPreferences.getBool(key) ?? false;
  }

  /// Gets a double value from SharedPreferences with given [key].
  double? getDouble(String key) {
    debugPrint('SharedPrefHelper : getDouble with key : $key');

    return _sharedPreferences.getDouble(key);
  }

  /// Gets an int value from SharedPreferences with given [key].
  int? getInt(String key) {
    debugPrint('SharedPrefHelper : getInt with key : $key');

    return _sharedPreferences.getInt(key);
  }

  /// Gets an String value from SharedPreferences with given [key].
  String? getString(String key) {
    debugPrint('SharedPrefHelper : getString with key : $key');

    return _sharedPreferences.getString(key);
  }

  Map<String, dynamic>? getMap(String key) {
    debugPrint('SharedPrefHelper : getMap with key : $key');

    String? jsonString = _sharedPreferences.getString(key);

    if (jsonString != null) {
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      return jsonMap;
    }
    return null;
  }

  /// Saves a [value] with a [key] in the _flutterSecureStorage.
  Future<void> setSecuredString(String key, String value) async {
    debugPrint(
      "FlutterSecureStorage : setSecuredString with key : $key and value : $value",
    );
    await _flutterSecureStorage.write(key: key, value: value);
  }

  /// Gets an String value from FlutterSecureStorage with given [key].
  Future<String?> getSecuredString(String key) async {
    debugPrint(
      'FlutterSecureStorage : getSecuredString with key : $key',
    );
    return await _flutterSecureStorage.read(key: key);
  }

  /// Removes a value from FlutterSecureStorage with given [key].
  void removeSecuredData(String key) async {
    debugPrint(
      'FlutterSecureStorage : data with key : $key has been removed',
    );
    await _flutterSecureStorage.delete(key: key);
  }

  /// Removes all keys and values in the FlutterSecureStorage
  void clearAllSecuredData() async {
    debugPrint('FlutterSecureStorage : all data has been cleared');
    await _flutterSecureStorage.deleteAll();
  }
}
