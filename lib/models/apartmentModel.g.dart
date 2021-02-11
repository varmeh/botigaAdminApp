// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apartmentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApartmentModel _$ApartmentModelFromJson(Map<String, dynamic> json) {
  return ApartmentModel(
    id: json['_id'] as String,
    name: json['apartmentName'] as String,
    area: json['apartmentArea'] as String,
    deliveryMessage: json['deliveryMessage'] as String,
    deliverySlot: json['deliverySlot'] as String,
  );
}

Map<String, dynamic> _$ApartmentModelToJson(ApartmentModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'apartmentName': instance.name,
      'apartmentArea': instance.area,
      'deliveryMessage': instance.deliveryMessage,
      'deliverySlot': instance.deliverySlot,
    };
