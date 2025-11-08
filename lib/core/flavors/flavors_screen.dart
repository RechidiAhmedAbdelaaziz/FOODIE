import 'package:flutter/material.dart';

import 'flavors.dart';

abstract class FlavorsScreen extends StatelessWidget {
  const FlavorsScreen({super.key});

  Widget get clientScreen => const Placeholder();
  Widget get ownerScreen => const Placeholder();
  Widget get serverScreen => const Placeholder();

  @override
  Widget build(BuildContext context) {
    switch (F.appFlavor) {
      case Flavor.client:
        return clientScreen;
      case Flavor.owner:
        return ownerScreen;
      case Flavor.server:
        return serverScreen;
    }
  }
}
