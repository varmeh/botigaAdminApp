import 'dart:io';
import 'package:flutter/material.dart';

import '../models/index.dart' show ApartmentModel, BannerModel;
import '../util/index.dart' show Http;

class ApartmentProvider with ChangeNotifier {
  ApartmentModel apartment;

  List<BannerModel> get banners => apartment != null ? apartment.banners : [];
  bool get hasBanners => banners.length > 0;

  Future<void> getApartment(String apartmentId) async {
    final json = await Http.get('/api/admin/apartments/$apartmentId');
    apartment = ApartmentModel.fromJson(json);
    notifyListeners();
  }

  void removeApartment() {
    apartment = null;
  }

  Future<void> addBanner(
      {String bannerUrl, String sellerId, int position = 1}) async {
    final json = await Http.post(
      '/api/admin/apartments/banners',
      body: {
        'apartmentId': apartment.id,
        'bannerUrl': bannerUrl,
        'sellerId': sellerId,
        'position': position,
      },
    );
    _updateBanners(json);
  }

  Future<void> removeBanner(BannerModel banner) async {
    final json = await Http.delete(
        '/api/admin/apartments/${apartment.id}/banners/${banner.id}');
    await Http.post('/api/admin/image/delete', body: {'imageUrl': banner.url});
    _updateBanners(json);
  }

  void _updateBanners(final json) {
    this.apartment.banners = json
        .map((bannerJson) => BannerModel.fromJson(bannerJson))
        .cast<BannerModel>()
        .toList();
    notifyListeners();
  }

  Future<String> uploadImage(File imageFile) async {
    final json = await Http.postImage('/api/admin/banners/image', imageFile);
    return json['imageUrl'];
  }
}
