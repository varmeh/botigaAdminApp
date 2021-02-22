// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sellerApartmentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SellerApartmentModel _$SellerApartmentModelFromJson(Map<String, dynamic> json) {
  return SellerApartmentModel(
    id: json['_id'] as String,
    name: json['apartmentName'] as String,
    area: json['apartmentArea'] as String,
    live: json['live'] as bool,
    deliveryMessage: json['deliveryMessage'] as String,
    deliverySlot: json['deliverySlot'] as String,
  );
}

Map<String, dynamic> _$SellerApartmentModelToJson(
        SellerApartmentModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'apartmentName': instance.name,
      'apartmentArea': instance.area,
      'live': instance.live,
      'deliveryMessage': instance.deliveryMessage,
      'deliverySlot': instance.deliverySlot,
    };
