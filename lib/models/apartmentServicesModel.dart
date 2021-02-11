import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'apartmentServicesModel.g.dart';

@JsonSerializable()
class ApartmentServicesModel {
  @JsonKey(name: '_id')
  final String id;

  final String name;
  final String area;
  final String city;
  final String state;
  final String pincode;

  ApartmentServicesModel({
    @required this.id,
    @required this.name,
    @required this.area,
    @required this.city,
    @required this.state,
    @required this.pincode,
  });

  factory ApartmentServicesModel.fromJson(Map<String, dynamic> json) =>
      _$ApartmentServicesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApartmentServicesModelToJson(this);
}
