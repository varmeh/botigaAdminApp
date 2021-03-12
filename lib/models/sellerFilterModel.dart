import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sellerFilterModel.g.dart';

@JsonSerializable()
class SellerFilterModel {
  @JsonKey(name: 'key')
  final String displayName;
  final String value;

  SellerFilterModel({
    @required this.displayName,
    @required this.value,
  });

  factory SellerFilterModel.fromJson(Map<String, dynamic> json) =>
      _$SellerFilterModelFromJson(json);

  Map<String, dynamic> toJson() => _$SellerFilterModelToJson(this);
}
