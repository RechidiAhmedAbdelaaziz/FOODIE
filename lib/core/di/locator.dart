import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locator.config.dart';

final locator = GetIt.instance;

@InjectableInit()
void configureDependencies() => locator.init();

Future<void> setupLocator() async {
  configureDependencies();

  // SharedPreferences and FlutterSecureStorage
  final sharedpref = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedpref);
  locator.registerLazySingleton(() => FlutterSecureStorage());


  locator.allowReassignment = true;
}
