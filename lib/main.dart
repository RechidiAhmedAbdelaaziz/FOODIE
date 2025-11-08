
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
    orElse: () => Flavor.owner,
  );

  // Initialize the dependency injection locator
  await setupLocator();

  locator<FlavorConfig>();

  // if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
  //   window_size.setWindowTitle(F.appFlavor.name);
  //   const phoneSize = Size(600, 1100); // modern phone-like logical size

  //   // window_size.setWindowMinSize(phoneSize);
  //   window_size.setWindowMaxSize(phoneSize); // fixed portrait size

  //   // Override the 800x600 frame set below with a microtask
  //   Future.microtask(() {
  //     window_size.setWindowFrame(
  //       Rect.fromLTWH(100, 100, phoneSize.width, phoneSize.height),
  //     );
  //   });
  //   window_size.setWindowFrame(const Rect.fromLTWH(100, 100, 800, 600));
  // }

  runApp(const App());
}
