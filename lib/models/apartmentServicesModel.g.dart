// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apartmentServicesModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApartmentServicesModel _$ApartmentServicesModelFromJson(
    Map<String, dynamic> json) {
  return ApartmentServicesModel(
    id: json['_id'] as String,
    name: json['name'] as String,
    area: json['area'] as String,
    city: json['city'] as String,
    state: json['state'] as String,
    pincode: json['pincode'] as String,
  );
}

Map<String, dynamic> _$ApartmentServicesModelToJson(
        ApartmentServicesModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'area': instance.area,
      'city': instance.city,
      'state': instance.state,
      'pincode': instance.pincode,
    };
