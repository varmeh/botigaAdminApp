import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/index.dart'
    show SellerProvider, ApartmentProvider, AdminProvider;
import './app/tabbar.dart';
import './app/splashScreen.dart';
import './app/auth/loginScreen.dart';

import 'util/index.dart' show Http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restricting Orientation to Portrait Mode only
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  await Http.fetchToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SellerProvider()),
        ChangeNotifierProvider(create: (context) => ApartmentProvider()),
        ChangeNotifierProvider(create: (context) => AdminProvider())
      ],
      child: BotigaAdminApp(),
    ),
  );
}

class BotigaAdminApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Botiga Admin App',
      themeMode: ThemeMode.light,
      initialRoute: SplashScreen.route,
      routes: {
        Tabbar.route: (_) => Tabbar(index: 0),
        SplashScreen.route: (_) => SplashScreen(),
        LoginScreen.route: (_) => LoginScreen()
      },
    );
  }
}
