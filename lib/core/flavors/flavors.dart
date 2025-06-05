import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:injectable/injectable.dart';

enum Flavor {
  client('FOODIE'),
  owner('FOODIE OWNER'),
  server('FOODIE SERVER');

  final String title;
  const Flavor(this.title);
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
      variables: {
        //TODO: Replace with actual base URL
        'baseUrl': dotenv.env['API_BASE_URL']!,
      },
    );
  }
}
