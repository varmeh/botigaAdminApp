import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'apartmentModel.g.dart';

@JsonSerializable()
class ApartmentModel {
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: 'apartmentName')
  final String name;

  @JsonKey(name: 'apartmentArea')
  final String area;

  final bool live;
  final String deliveryMessage;
  final String deliverySlot;

  ApartmentModel({
    @required this.id,
    @required this.name,
    @required this.area,
    this.live,
    this.deliveryMessage,
    this.deliverySlot,
  });

  factory ApartmentModel.fromJson(Map<String, dynamic> json) =>
      _$ApartmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApartmentModelToJson(this);
}
