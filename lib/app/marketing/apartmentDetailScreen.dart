import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/index.dart' show Http;
import '../../widgets/index.dart' show BotigaAppBar, LoaderOverlay, Toast;
import '../../provider/index.dart' show ApartmentProvider;
import '../../models/index.dart' show ApartmentServicesModel, BannerModel;

class ApartmentDetailScreen extends StatefulWidget {
  final ApartmentServicesModel apartment;

  ApartmentDetailScreen(this.apartment);

  @override
  _ApartmentDetailScreenState createState() => _ApartmentDetailScreenState();
}

class _ApartmentDetailScreenState extends State<ApartmentDetailScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 100), () => _getApartmentDetails());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ApartmentProvider>(context, listen: false);

    return Scaffold(
      appBar: BotigaAppBar(widget.apartment.name),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: LoaderOverlay(
            isLoading: _isLoading,
            child: ListView(
              children: [
                ...provider.banners.map((banner) {
                  _bannerTile(banner);
                }).toList()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bannerTile(BannerModel banner) {
    return InkWell(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),
          Image.network(
            banner.url,
            width: double.infinity - 40,
            height: 160,
          )
        ],
      ),
    );
  }

  Future<void> _getApartmentDetails() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<ApartmentProvider>(context, listen: false)
          .getApartment(widget.apartment.id);
    } catch (error) {
      Toast(message: Http.message(error)).show(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
