part of 'geo_locator_service.dart';

/// A service to handle geolocation operations using Google Maps.
/// Eamil: 'https://maps.app.goo.gl/ScYoDBkZaJGEmNpP7'
///
Future<LangLatModel> _getLangLat(String shortUrl) async {
  final dio = Dio(
    BaseOptions(
      followRedirects: false,
      validateStatus: (status) =>
          status != null && (status >= 200 && status < 400),
    ),
  )..addLogger();

  String? currentUrl = shortUrl;
  int maxRedirects = 5;

  while (currentUrl != null && maxRedirects-- > 0) {
    final response = await dio.get(currentUrl);
    final locationHeader = response.headers.value('location');

    // Check redirect URL for coordinates
    final redirectUrl = locationHeader ?? currentUrl;
    final redirectMatch = _extractCoordinates(redirectUrl);
    if (redirectMatch != null) {
      dio.close();
      return redirectMatch;
    }

    // If it's the final page (200 OK), search in the body
    if (response.statusCode == 200 && response.data is String) {
      final html = response.data as String;
      final bodyMatch = _extractCoordinates(html);
      if (bodyMatch != null) {
        dio.close();
        return bodyMatch;
      }
    }

    // Go to next URL in chain
    currentUrl = locationHeader;
  }

  dio.close();
  throw Exception('Coordinates not found in redirects or HTML body.');
}

LangLatModel? _extractCoordinates(String input) {
  final regex = RegExp(r'(-?\d+\.\d+),\s*(-?\d+\.\d+)');
  final matches = regex.allMatches(input);

  for (final match in matches) {
    try {
      final lat = double.parse(match.group(1)!);
      final lng = double.parse(match.group(2)!);
      if (_isValidLatLng(lat, lng)) {
        return LangLatModel(latitude: lat, longitude: lng);
      }
    } catch (_) {}
  }

  return null;
}

bool _isValidLatLng(double lat, double lng) {
  return lat.abs() <= 90 && lng.abs() <= 180;
}
