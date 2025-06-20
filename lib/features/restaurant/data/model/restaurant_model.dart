import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

@JsonSerializable(createToJson: false)
class RestaurantModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final List<String>? categories;
  final String? description;
  final String? image;
  final LocationModel? address;
  final List<String>? openingDays;

  final String? startTime; // ##:## AM
  final String? endTime; // ##:## PM

  final bool? isPrePaid;

  final String? facebookLink;
  final String? instagramLink;
  final String? tiktokLink;

  final String? phone;

  bool get isNightTimeOpen {
    if (startTime == null || endTime == null) return false;

    final start = DateTime.parse('2023-01-01 $startTime');
    final end = DateTime.parse('2023-01-01 $endTime');

    // If the end time is before the start time, it means it goes past midnight
    if (end.isBefore(start)) {
      return DateTime.now().isAfter(start) ||
          DateTime.now().isBefore(end);
    } else {
      return DateTime.now().isAfter(start) &&
          DateTime.now().isBefore(end);
    }
  }

  const RestaurantModel({
    this.id,
    this.name,
    this.categories,
    this.description,
    this.image,
    this.address,
    this.openingDays,
    this.startTime,
    this.endTime,
    this.isPrePaid,
    this.facebookLink,
    this.instagramLink,
    this.tiktokLink,
    this.phone,
  });

  @override
  List<Object?> get props => [id];

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class LocationModel {
  final String? title;
  final String? longitude;
  final String? latitude;

  const LocationModel({this.title, this.longitude, this.latitude});

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);
}
