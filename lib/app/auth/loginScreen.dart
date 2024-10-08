import 'package:flutter/material.dart';

import './shared/phoneScreen.dart';
import 'verifyOtpScreen.dart';

class LoginScreen extends StatelessWidget {
  static final route = 'login';

  @override
  Widget build(BuildContext context) {
    return PhoneScreen(
      title: 'Login',
      navigate: (String phoneNumber) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VerifyOtpScreen(phoneNumber),
          ),
        );
      },
    );
  }
}
