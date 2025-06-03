import 'package:app/core/di/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

import 'app.dart';
import 'core/flavors/flavors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the preferred orientations
  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );

  // Initialize the dependency injection locator
  await setupLocator();

  //Run the app in a specific flavor
  locator<FlavorConfig>();

  runApp(const App());
}
