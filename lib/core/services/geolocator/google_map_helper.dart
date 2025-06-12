part of 'geo_locator_service.dart';

/// A service to handle geolocation operations using Google Maps.
/// Eamil: 'https://maps.app.goo.gl/ScYoDBkZaJGEmNpP7'
///
Future<LangLatModel> _getLangLat(String shortUrl) async {
  final dio = Dio(
    BaseOptions(
      followRedirects: false, // We want to catch the redirect
      validateStatus: (status) =>
          status! < 400, // Allow redirect (3xx)
    ),
  );

  // First request to get the redirected long URL
  final response = await dio.get(shortUrl);
  dio.close();

  final redirectedUrl = response.headers.value('location');

  if (redirectedUrl == null) {
    throw Exception('We get null from the redirected URL');
  }

  final regex = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)');
  final match = regex.firstMatch(redirectedUrl);

  final latitude = match!.group(1);
  final longitude = match.group(2);
  return LangLatModel(
    latitude: double.parse(latitude!),
    longitude: double.parse(longitude!),
  );
}
