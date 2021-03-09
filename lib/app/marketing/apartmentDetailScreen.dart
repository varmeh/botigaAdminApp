import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:provider/provider.dart';

import '../../util/index.dart' show Http, AppTheme, TextStyleHelpers;
import '../../widgets/index.dart' show BotigaAppBar, LoaderOverlay, Toast;
import '../../provider/index.dart' show ApartmentProvider;
import '../../models/index.dart' show ApartmentServicesModel, BannerModel;

import 'addBanner.dart';

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
    final provider = Provider.of<ApartmentProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar(widget.apartment.name),
      floatingActionButton: _addBannerButton(provider),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: LoaderOverlay(
            isLoading: _isLoading,
            child: ListView(
              children: [
                ...provider.hasBanners
                    ? provider.banners
                        .map((banner) => _bannerTile(banner, provider))
                    : [
                        Center(
                          child: Text(
                            'No Banners here'.toUpperCase(),
                            style: AppTheme.textStyle.w500.color100
                                .size(22)
                                .lineHeight(1.4),
                          ),
                        )
                      ]
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
                  onTap: () => _removeBanner(provider, banner),
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

  Widget _addBannerButton(ApartmentProvider provider) {
    return provider.banners.length < 5
        ? Padding(
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
                    'Add Banner',
                    style: AppTheme.textStyle
                        .size(15)
                        .w700
                        .letterSpace(1)
                        .colored(AppTheme.primaryColor),
                  ),
                  onPressed: () => openContainer(),
                );
              },
              openBuilder: (_, __) => AddBannerScreen(),
            ),
          )
        : Container();
  }

  void _removeBanner(ApartmentProvider provider, BannerModel banner) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Banner',
          style: AppTheme.textStyle.w500.color100,
        ),
        content: Text(
          'Are you sure you want to delete this banner?',
          style: AppTheme.textStyle.w400.color100,
        ),
        actions: [
          FlatButton(
            child: Text(
              'Confirm',
              style: AppTheme.textStyle.w600.colored(AppTheme.errorColor),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              setState(() => _isLoading = true);
              try {
                await provider.removeBanner(banner);
              } catch (error) {
                Toast(message: Http.message(error)).show(context);
              } finally {
                setState(() => _isLoading = false);
              }
            },
          ),
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
