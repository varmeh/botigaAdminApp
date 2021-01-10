import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sellerModel.g.dart';

@JsonSerializable()
class SellerModel {
  final String businessName;
  final String businessType;
  final String businessCategory;
  final String gstin;
  final String owner;
  final String brand;
  final String tagline;
  final String brandImageUrl;
  final String phone;
  final String whatsapp;
  final String email;

  bool editable;
  bool verified;
  final String beneficiaryName;
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String accountType;

  final String mid;
  final String fssaiNumber;
  final DateTime fssaiValidityDate;
  final String fssaiCertificateUrl;

  SellerModel({
    @required this.businessName,
    this.businessType,
    @required this.businessCategory,
    this.gstin,
    @required this.owner,
    @required this.brand,
    @required this.tagline,
    @required this.brandImageUrl,
    @required this.phone,
    @required this.whatsapp,
    @required this.email,
    @required this.editable,
    @required this.verified,
    @required this.beneficiaryName,
    @required this.accountNumber,
    @required this.ifscCode,
    @required this.bankName,
    @required this.accountType,
    @required this.mid,
    this.fssaiNumber,
    this.fssaiValidityDate,
    this.fssaiCertificateUrl,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) =>
      _$SellerModelFromJson(json);

  Map<String, dynamic> toJson() => _$SellerModelToJson(this);
}
