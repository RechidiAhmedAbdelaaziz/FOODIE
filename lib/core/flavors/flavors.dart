import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:injectable/injectable.dart';

enum Flavor {
  client('FOODIE', "Client"),
  owner('FOODIE OWNER', "Owner"),
  server('FOODIE SERVER', "Staff");

  final String title;
  final String role;
  const Flavor(this.title, this.role);
}

abstract class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;
}

@module
abstract class FlavorConfigModule {
  @lazySingleton
  FlavorConfig get config {
    return FlavorConfig(
      name: F.name,
      variables: {'baseUrl': dotenv.env['API_BASE_URL']!},
    );
  }
}
