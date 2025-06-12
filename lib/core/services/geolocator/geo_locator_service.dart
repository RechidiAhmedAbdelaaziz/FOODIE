import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'dart:core';
import 'package:geolocator/geolocator.dart';

part 'google_map_helper.dart';
part 'lang_lat_model.dart';

@lazySingleton
class GeoLocatorService {
  Future<LangLatModel> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
        'Location services are disabled. Please enable the services to proceed.',
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception(
          'Location permissions are denied. Please grant permission to proceed.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    return LangLatModel.fromPosition(
      await Geolocator.getCurrentPosition(),
    );
  }

  Future<LangLatModel> getLangLatFromShortUrl(
    String shortUrl,
  ) async => _getLangLat(shortUrl);
}
