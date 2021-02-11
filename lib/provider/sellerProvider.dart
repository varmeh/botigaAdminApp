import 'package:flutter/material.dart';

import '../models/index.dart' show SellerModel;
import '../util/index.dart' show Http;

class SellerProvider with ChangeNotifier {
  SellerModel seller;

  bool get hasSeller => seller != null;

  Future<void> getSeller(String phone) async {
    final json = await Http.get('/api/admin/seller/$phone');
    seller = SellerModel.fromJson(json);
    notifyListeners();
  }

  void removeSeller() {
    seller = null;
  }

  Future<void> updateMid(String mid) async {
    final json = await Http.patch(
      '/api/admin/seller/bankDetails',
      body: {
        'phone': seller.phone,
        'mid': mid,
      },
    );
    seller = SellerModel.fromJson(json);
  }

  Future<String> getTestOrderId(String amount) async {
    final json = await Http.post(
      '/api/admin/transaction/test',
      body: {
        'phone': seller.phone,
        'txnAmount': amount,
      },
    );
    return json['id'];
  }

  Future<void> notifySellerOfSuccessfulTestTransaction(
      String amount, String txnId) async {
    await Http.post(
      '/api/admin/transaction/test/notify',
      body: {'phone': seller.phone, 'txnAmount': amount, 'paymentId': txnId},
    );
  }

  Future<void> bankDetailsEditable(bool editable) async {
    final json = await Http.patch(
      '/api/admin/seller/bankDetails',
      body: {
        'phone': seller.phone,
        'editable': editable,
      },
    );
    seller = SellerModel.fromJson(json);
  }

  Future<void> bankDetailsVerified(bool verified) async {
    final json = await Http.patch(
      '/api/admin/seller/bankDetails',
      body: {
        'phone': seller.phone,
        'verified': verified,
      },
    );
    seller = SellerModel.fromJson(json);
  }

  Future<void> addApartment(String apartmentId) async {
    await Http.post(
      '/api/admin/seller/apartment',
      body: {
        'phone': seller.phone,
        'apartmentId': apartmentId,
      },
    );
    await getSeller(seller.phone);
  }

  Future<void> removeApartment(String apartmentId) async {
    await Http.delete(
        '/api/admin/seller/${seller.phone}/apartments/$apartmentId');
    await getSeller(seller.phone);
  }

  Future<void> updateApartmentStatus(String apartmentId, bool live) async {
    await Http.patch(
      '/api/admin/seller/apartment/live',
      body: {
        'phone': seller.phone,
        'apartmentId': apartmentId,
        'live': live,
      },
    );
  }
}
