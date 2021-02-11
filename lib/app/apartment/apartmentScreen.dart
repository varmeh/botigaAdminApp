import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import '../../util/index.dart';
import '../../widgets/index.dart' show LoaderOverlay, Toast;
import '../../provider/index.dart' show SellerProvider;

import 'apartmentTile.dart';
import 'addApartment.dart';

class ApartmentScreen extends StatefulWidget {
  @override
  _ApartmentScreenState createState() => _ApartmentScreenState();
}

class _ApartmentScreenState extends State<ApartmentScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SellerProvider>(context);

    if (!provider.hasSeller) {
      return SafeArea(
        child: Center(
          child: Text(
            'Please select a seller first!!!',
            style: AppTheme.textStyle.w700.color100.size(17).lineHeight(1.3),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      floatingActionButton: _addCommunityButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: LoaderOverlay(
        isLoading: _isLoading,
        child: SafeArea(
          child: Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: ListView.builder(
              itemCount: provider.seller.apartments.length,
              itemBuilder: (context, index) {
                return ApartmentTile(
                  apartment: provider.seller.apartments[index],
                  changeApartmentStatusFunction: onApartmentStatusChange,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _addCommunityButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: 28.0),
      child: OpenContainer(
        closedColor: AppTheme.backgroundColor,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        closedElevation: 4.0,
        transitionDuration: Duration(milliseconds: 300),
        closedBuilder: (context, openContainer) {
          return FloatingActionButton.extended(
            backgroundColor: AppTheme.backgroundColor,
            elevation: 4.0,
            icon: const Icon(Icons.add, color: Color(0xff179F57)),
            label: Text(
              'Add Apartment',
              style: AppTheme.textStyle
                  .size(15)
                  .w700
                  .letterSpace(1)
                  .colored(AppTheme.primaryColor),
            ),
            onPressed: () => openContainer(),
          );
        },
        openBuilder: (_, __) => AddApartment(),
      ),
    );
  }

  void onApartmentStatusChange(
      String aptId, bool value, Function onFail) async {
    setState(() => _isLoading = true);
    try {
      // final provider = Provider.of<SellerProvider>(context, listen: false);
      // await provider.setApartmentStatus(aptId, value);
      // await provider.fetchProfile();
      Toast(
        message: 'Community status updated',
        icon: Icon(
          Icons.check_circle,
          size: 24,
          color: AppTheme.backgroundColor,
        ),
      ).show(context);
    } catch (err) {
      onFail();
      Toast(message: Http.message(err)).show(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
