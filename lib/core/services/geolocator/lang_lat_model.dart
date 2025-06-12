part of './geo_locator_service.dart';

class LangLatModel {
  final double latitude;
  final double longitude;

  LangLatModel({required this.latitude, required this.longitude});

  factory LangLatModel.fromPosition(Position position) {
    return LangLatModel(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}
