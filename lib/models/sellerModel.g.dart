// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sellerModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SellerModel _$SellerModelFromJson(Map<String, dynamic> json) {
  return SellerModel(
    businessName: json['businessName'] as String,
    businessType: json['businessType'] as String,
    businessCategory: json['businessCategory'] as String,
    gstin: json['gstin'] as String,
    owner: json['owner'] as String,
    brand: json['brand'] as String,
    tagline: json['tagline'] as String,
    brandImageUrl: json['brandImageUrl'] as String,
    phone: json['phone'] as String,
    whatsapp: json['whatsapp'] as String,
    email: json['email'] as String,
    editable: json['editable'] as bool,
    verified: json['verified'] as bool,
    beneficiaryName: json['beneficiaryName'] as String,
    accountNumber: json['accountNumber'] as String,
    ifscCode: json['ifscCode'] as String,
    bankName: json['bankName'] as String,
    accountType: json['accountType'] as String,
    mid: json['mid'] as String,
    fssaiNumber: json['fssaiNumber'] as String,
    fssaiValidityDate: json['fssaiValidityDate'] == null
        ? null
        : DateTime.parse(json['fssaiValidityDate'] as String),
    fssaiCertificateUrl: json['fssaiCertificateUrl'] as String,
    apartments: (json['apartments'] as List)
        ?.map((e) => e == null
            ? null
            : ApartmentModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SellerModelToJson(SellerModel instance) =>
    <String, dynamic>{
      'businessName': instance.businessName,
      'businessType': instance.businessType,
      'businessCategory': instance.businessCategory,
      'gstin': instance.gstin,
      'owner': instance.owner,
      'brand': instance.brand,
      'tagline': instance.tagline,
      'brandImageUrl': instance.brandImageUrl,
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
      'email': instance.email,
      'apartments': instance.apartments,
      'editable': instance.editable,
      'verified': instance.verified,
      'beneficiaryName': instance.beneficiaryName,
      'accountNumber': instance.accountNumber,
      'ifscCode': instance.ifscCode,
      'bankName': instance.bankName,
      'accountType': instance.accountType,
      'mid': instance.mid,
      'fssaiNumber': instance.fssaiNumber,
      'fssaiValidityDate': instance.fssaiValidityDate?.toIso8601String(),
      'fssaiCertificateUrl': instance.fssaiCertificateUrl,
    };
