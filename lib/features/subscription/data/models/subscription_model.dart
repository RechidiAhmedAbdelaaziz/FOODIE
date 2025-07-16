import 'package:json_annotation/json_annotation.dart';

part 'subscription_model.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionModel {
  final DateTime expirationDate;
  final String type;

  bool get isActive => expirationDate.isAfter(DateTime.now());

  SubscriptionModel({
    required this.expirationDate,
    required this.type,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);
}
