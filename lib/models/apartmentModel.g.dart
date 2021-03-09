// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apartmentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApartmentModel _$ApartmentModelFromJson(Map<String, dynamic> json) {
  return ApartmentModel(
    id: json['_id'] as String,
    name: json['name'] as String,
    area: json['area'] as String,
    city: json['city'] as String,
    state: json['state'] as String,
    pincode: json['pincode'] as String,
    banners: (json['marketingBanners'] as List)
        ?.map((e) =>
            e == null ? null : BannerModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..sellers = (json['sellers'] as List)
      ?.map((e) => e == null
          ? null
          : ApartmentSellerModel.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

Map<String, dynamic> _$ApartmentModelToJson(ApartmentModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'area': instance.area,
      'city': instance.city,
      'state': instance.state,
      'pincode': instance.pincode,
      'marketingBanners': instance.banners,
      'sellers': instance.sellers,
    };

ApartmentSellerModel _$ApartmentSellerModelFromJson(Map<String, dynamic> json) {
  return ApartmentSellerModel(
    id: json['_id'] as String,
    brandName: json['brandName'] as String,
    tagline: json['tagline'] as String,
    brandImageUrl: json['brandImageUrl'] as String,
    businessCategory: json['businessCategory'] as String,
    live: json['live'] as bool,
  )..banners = (json['marketingBanners'] as List)
      ?.map((e) =>
          e == null ? null : BannerModel.fromJson(e as Map<String, dynamic>))
      ?.toList();
}

Map<String, dynamic> _$ApartmentSellerModelToJson(
        ApartmentSellerModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'brandName': instance.brandName,
      'tagline': instance.tagline,
      'brandImageUrl': instance.brandImageUrl,
      'businessCategory': instance.businessCategory,
      'live': instance.live,
      'marketingBanners': instance.banners,
    };
