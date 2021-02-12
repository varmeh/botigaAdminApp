import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/index.dart' show SellerModel, CategoryModel;
import '../../../provider/index.dart' show SellerProvider;
import '../../../util/index.dart';
import '../../../widgets/index.dart' show BotigaAppBar;

import 'widgets/index.dart' show SellerBrandContainer, CategoryList, FssaiTile;

class StoreScreen extends StatelessWidget {
  static String route = 'productsScreen';

  @override
  Widget build(BuildContext context) {
    final seller = Provider.of<SellerProvider>(context).seller;
    final _divider = Divider(
      thickness: 4.0,
      color: AppTheme.dividerColor,
    );

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar(''),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            if (index == 0) {
              return SellerBrandContainer(seller);
            } else if (index == 1) {
              return Column(
                children: [
                  _divider,
                  _categoryList(context, seller),
                ],
              );
            } else {
              return Column(
                children: [
                  _divider,
                  FssaiTile(seller),
                  SizedBox(height: 60.0),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _categoryList(BuildContext context, SellerModel seller) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Categories',
            style: AppTheme.textStyle.w700.color100.size(17),
          ),
          SizedBox(height: 20),
          _productList(context, seller),
        ],
      ),
    );
  }

  Widget _productList(BuildContext context, SellerModel seller) {
    return Column(
      children: [
        ...seller.categories.asMap().entries.map((entry) {
          int idx = entry.key;
          CategoryModel category = entry.value;
          bool isLast = idx == seller.categories.length - 1;
          return CategoryList(
            category: category,
            seller: seller,
            isLast: isLast,
          );
        })
      ],
    );
  }
}
