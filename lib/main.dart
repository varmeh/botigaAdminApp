import 'package:botigaAdminApp/app/tabbar.dart';
import 'package:botigaAdminApp/util/appTheme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restricting Orientation to Portrait Mode only
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(BotigaAdminApp());
}

class BotigaAdminApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Botiga Admin App',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: AppTheme.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Tabbar.route,
      routes: {
        Tabbar.route: (_) => Tabbar(index: 0),
      },
    );
  }
}
