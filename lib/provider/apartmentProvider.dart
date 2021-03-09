import 'package:flutter/material.dart';

import '../models/index.dart' show ApartmentModel, BannerModel;
import '../util/index.dart' show Http;

class ApartmentProvider with ChangeNotifier {
  ApartmentModel apartment;

  List<BannerModel> get banners => apartment != null ? apartment.banners : [];

  Future<void> getApartment(String apartmentId) async {
    final json = await Http.get('/api/admin/apartments/$apartmentId');
    apartment = ApartmentModel.fromJson(json);
    notifyListeners();
  }

  void removeApartment() {
    apartment = null;
  }

  Future<void> addBanner(
      {String bannerUrl, String sellerId, int position = 0}) async {
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

  Future<void> removeBanner(String bannerId) async {
    final json = await Http.delete(
        '/api/admin/apartments/${apartment.id}/banners/$bannerId');
    _updateBanners(json);
  }

  void _updateBanners(final json) {
    this.apartment.banners = json
        .map((bannerJson) => BannerModel.fromJson(bannerJson))
        .cast<BannerModel>()
        .toList();
    notifyListeners();
  }
}
