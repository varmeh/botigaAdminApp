import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sellerApartmentModel.g.dart';

@JsonSerializable()
class SellerApartmentModel {
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: 'apartmentName')
  final String name;

  @JsonKey(name: 'apartmentArea')
  final String area;

  final bool live;
  final String deliveryMessage;
  final String deliverySlot;

  SellerApartmentModel({
    @required this.id,
    @required this.name,
    @required this.area,
    this.live,
    this.deliveryMessage,
    this.deliverySlot,
  });

  factory SellerApartmentModel.fromJson(Map<String, dynamic> json) =>
      _$SellerApartmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$SellerApartmentModelToJson(this);
}
