enum Flavor {
  client,
  owner,
  server,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.client:
        return 'FOODIE';
      case Flavor.owner:
        return 'FOODIE OWNER';
      case Flavor.server:
        return 'FOODIE SERVER';
    }
  }

}
