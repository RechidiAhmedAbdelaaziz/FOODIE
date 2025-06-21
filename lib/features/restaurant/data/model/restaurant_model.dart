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
  final List<WorkingTimeModel>? workingTimes;

  final bool? isPrePaid;

  final String? facebookLink;
  final String? instagramLink;
  final String? tiktokLink;

  final String? phone;

  bool get isNightTimeOpen {
    if (workingTimes == null || workingTimes!.isEmpty) return false;

    return workingTimes!.any((time) {
      final start = time.startTime?.split(':');
      final end = time.endTime?.split(':');
      if (start == null || end == null) return false;

      final startHour = int.parse(start[0]);
      final endHour = int.parse(end[0]);

      // Check if the restaurant is open during night hours (22:00 - 06:00)
      return (startHour >= 22 || startHour < 6) &&
          (endHour >= 22 || endHour < 6);
    });
  }

  const RestaurantModel({
    this.id,
    this.name,
    this.categories,
    this.description,
    this.image,
    this.address,
    this.workingTimes,
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

@JsonSerializable(createToJson: false)
class WorkingTimeModel {
  final String? day;
  final String? startTime; // ##:##
  final String? endTime; // ##:##

  const WorkingTimeModel({this.day, this.startTime, this.endTime});

  factory WorkingTimeModel.fromJson(Map<String, dynamic> json) =>
      _$WorkingTimeModelFromJson(json);
}
