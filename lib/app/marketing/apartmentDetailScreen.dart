import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/index.dart' show Http, AppTheme, TextStyleHelpers;
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
                  return _bannerTile(banner, provider);
                }).toList()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bannerTile(BannerModel banner, ApartmentProvider provider) {
    final seller = provider.apartment.seller(banner.sellerId);
    final sellerTitle =
        seller != null ? seller.brandName : 'No Seller Attached';

    return InkWell(
      onTap: () {},
      child: Padding(
        padding:
            const EdgeInsets.only(top: 24, bottom: 24, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              banner.url,
              fit: BoxFit.fill,
              width: double.infinity,
              height: 160,
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sellerTitle,
                  style:
                      AppTheme.textStyle.w500.color100.size(20).lineHeight(1.3),
                ),
                SizedBox(width: 24),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: Icon(
                    Icons.delete,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Divider(
              thickness: 1,
              color: AppTheme.dividerColor,
            ),
          ],
        ),
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
