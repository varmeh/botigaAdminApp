import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/index.dart';

import 'payment/sellerScreen.dart';
import 'apartment/apartmentScreen.dart';

class Tabbar extends StatefulWidget {
  static String route = 'tabbar';

  final int index;

  Tabbar({@required this.index});

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> with WidgetsBindingObserver {
  int _selectedIndex;

  List<Widget> _selectedTab = [
    SellerScreen(),
    ApartmentScreen(),
  ];

  void changeTab(int index) {
    setState(() => _selectedIndex = index);
    setStatusBarBrightness();
  }

  void setStatusBarBrightness() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ));
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
    setStatusBarBrightness();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _selectedTab.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppTheme.backgroundColor,
        selectedItemColor: AppTheme.primaryColor,
        iconSize: 28,
        selectedLabelStyle: AppTheme.textStyle.w500.size(14),
        unselectedLabelStyle: AppTheme.textStyle.w500.size(14),
        unselectedItemColor: AppTheme.navigationItemColor,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'Seller',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_business),
            label: 'Apartment',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: changeTab,
      ),
    );
  }
}
