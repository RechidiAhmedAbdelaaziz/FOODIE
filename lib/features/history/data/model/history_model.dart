import 'package:json_annotation/json_annotation.dart';

part 'history_model.g.dart';

@JsonSerializable(createToJson: false)
class HistoryModel {
  final String? amount;
  final DateTime? date;

  HistoryModel({this.amount, this.date});

  factory HistoryModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryModelFromJson(json);
}
