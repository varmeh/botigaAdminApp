import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'bannerModel.dart';

part 'apartmentModel.g.dart';

@JsonSerializable()
class ApartmentModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String area;
  final String city;
  final String state;
  final String pincode;

  @JsonKey(name: 'marketingBanners')
  List<BannerModel> banners;

  List<ApartmentSellerModel> sellers;

  ApartmentModel({
    @required this.id,
    @required this.name,
    @required this.area,
    this.city,
    this.state,
    this.pincode,
    this.banners,
  });

  factory ApartmentModel.fromJson(Map<String, dynamic> json) =>
      _$ApartmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApartmentModelToJson(this);
}

@JsonSerializable()
class ApartmentSellerModel {
  @JsonKey(name: '_id')
  final String id;

  final String brandName;
  final String tagline;
  final String brandImageUrl;
  final String businessCategory;
  final bool live;

  @JsonKey(name: 'marketingBanners')
  List<BannerModel> banners;

  ApartmentSellerModel({
    @required this.id,
    @required this.brandName,
    @required this.tagline,
    this.brandImageUrl,
    this.businessCategory,
    this.live,
  });

  factory ApartmentSellerModel.fromJson(Map<String, dynamic> json) =>
      _$ApartmentSellerModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApartmentSellerModelToJson(this);
}
