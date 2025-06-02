import 'package:app/core/routing/routers/router.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:injectable/injectable.dart';

import 'flavors.dart';

@module
abstract class FlavorConfigs {
  @lazySingleton
  AppRouter provideAppRouter() {
    switch (F.appFlavor) {
      case Flavor.client:
        return ClientRouter();
      case Flavor.owner:
        return OwnerRouter();
      case Flavor.server:
        return ServerRouter();
    }
  }

  @lazySingleton
  FlavorConfig provideFlavorConfig() {
    return FlavorConfig(
      name: F.name,
      variables: {
        //TODO: Replace with actual base URL
        'baseUrl': 'https://api.foodie.com',
      },
    );
  }
}
