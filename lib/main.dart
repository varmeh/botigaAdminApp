import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/index.dart' show SellerProvider;
import './app/tabbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restricting Orientation to Portrait Mode only
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SellerProvider())
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
      initialRoute: Tabbar.route,
      routes: {
        Tabbar.route: (_) => Tabbar(index: 0),
      },
    );
  }
}
