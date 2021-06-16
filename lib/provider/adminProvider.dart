import 'package:flutter/foundation.dart';

import '../util/index.dart' show Http, Token;

class AdminProvider with ChangeNotifier {
  String firstName;
  String lastName;
  String phone;
  String whatsapp;
  String email;

  bool get isLoggedIn => phone != null;

  void _fillProvider(final json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    phone = json['phone'];
    whatsapp = json['whatsapp'];
    email = json['email'];
  }

  Future<void> getProfile() async {
    final json = await Http.get('/api/admin/auth/profile');
    _fillProvider(json);
  }

  Future<void> logout() async {
    await Http.post('/api/admin/auth/signout');
    phone = null;
    firstName = null;
    lastName = null;
    whatsapp = null;
    email = null;
    await Token.write('');
  }

  Future<void> otpAuth({String phone, String sessionId, String otp}) async {
    final json = await Http.postAuth('/api/admin/auth/otp/verify', body: {
      'phone': phone,
      'sessionId': sessionId,
      'otpVal': otp,
    });

    _fillProvider(json);
  }
}
