import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'staff_model.g.dart';

@JsonSerializable(createToJson: false)
class StaffModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final int? amount;
  final String? name;
  final String? login;

  const StaffModel({this.id, this.amount, this.name, this.login});

  factory StaffModel.fromJson(Map<String, dynamic> json) =>
      _$StaffModelFromJson(json);

  @override
  List<Object?> get props => [id];
}
