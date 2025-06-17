
import 'package:app/features/restaurant/data/model/restaurant_model.dart';
import 'package:app/features/staff/data/model/staff_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'table_model.g.dart';

@JsonSerializable(createToJson: false)
class TableModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;

  final RestaurantModel? restaurant;

  final List<StaffModel> staff;
  final bool? forAllStaff;

  const TableModel({
    this.id,
    this.name,
    this.staff = const [],
    this.forAllStaff,
    this.restaurant,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) =>
      _$TableModelFromJson(json);



  @override
  List<Object?> get props => [id];
}
