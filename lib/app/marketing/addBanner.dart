import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/index.dart';
import '../../widgets/index.dart'
    show
        BotigaAppBar,
        LoaderOverlay,
        ImageSelectionWidget,
        BotigaBottomModal,
        ActiveButton,
        PassiveButton;
import '../../models/index.dart' show ApartmentSellerModel;
import '../../provider/index.dart' show ApartmentProvider;

class AddBannerScreen extends StatefulWidget {
  AddBannerScreen({Key key}) : super(key: key);

  @override
  _AddBannerScreenState createState() => _AddBannerScreenState();
}

class _AddBannerScreenState extends State<AddBannerScreen> {
  bool _isLoading = false;
  File _imageFile;
  ApartmentSellerModel _seller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar('Add Banner'),
      bottomNavigationBar: _uploadButton(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: LoaderOverlay(
            isLoading: _isLoading,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
              child: ListView(
                children: [
                  _imageSelectionWidget(),
                  SizedBox(height: 24),
                  _sellerSelectionWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageSelectionWidget() {
    return _imageFile != null
        ? Column(
            children: [
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  child: Image.file(
                    File(_imageFile.path),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: PassiveButton(
                      title: 'Change',
                      onPressed: () => _selectImage(context),
                      icon: Icon(
                        Icons.edit,
                        color: AppTheme.color100,
                        size: 17,
                      ),
                      height: 44,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: PassiveButton(
                      title: 'Remove',
                      onPressed: () => setState(() => _imageFile = null),
                      icon: Icon(
                        Icons.delete_outline,
                        color: AppTheme.color100,
                        size: 17,
                      ),
                      height: 44,
                    ),
                  )
                ],
              )
            ],
          )
        : Container(
            width: double.infinity,
            height: 176,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                style: BorderStyle.solid,
                color: AppTheme.color100.withOpacity(0.25),
                width: 1.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlatButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 14,
                      bottom: 14,
                    ),
                    child: Icon(Icons.collections, size: 18),
                  ),
                  onPressed: () => _selectImage(context),
                  color: Colors.black.withOpacity(0.05),
                  label: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      top: 14,
                      bottom: 14,
                      left: 8,
                    ),
                    child: Text('Add Image',
                        style: AppTheme.textStyle.color100.w500.size(15)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 55,
                    right: 55,
                    top: 16,
                  ),
                  child: Text(
                    'Select Banner Image with dimensions 960x480px',
                    textAlign: TextAlign.center,
                    style: AppTheme.textStyle.color50.w400
                        .size(12)
                        .letterSpace(0.2)
                        .lineHeight(1.5),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _sellerSelectionWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.5),
        border: Border.all(
          style: BorderStyle.solid,
          color: AppTheme.color25,
          width: 1.0,
        ),
      ),
      child: ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: -1),
        onTap: () {
          FocusScope.of(context).unfocus();
          showCategories();
        },
        trailing: Icon(Icons.keyboard_arrow_down, color: AppTheme.color100),
        title: _seller == null
            ? Text(
                'Select Seller',
                style: AppTheme.textStyle.color100.w500.size(15),
              )
            : Text(
                _seller.brandName,
                style: AppTheme.textStyle.color100.w500.size(15),
              ),
      ),
    );
  }

  Widget _uploadButton() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: _imageFile != null && _seller != null
            ? ActiveButton(title: 'Upload Banner', onPressed: () {})
            : PassiveButton(title: 'Upload Banner', onPressed: () {}),
      ),
    );
  }

  void _selectImage(BuildContext context) {
    ImageSelectionWidget(
      width: 960,
      height: 480,
      onImageSelection: (imageFile) => setState(() => _imageFile = imageFile),
    ).show(context);
  }

  void showCategories() {
    List widgets = [];
    final sellers = Provider.of<ApartmentProvider>(context, listen: false)
        .apartment
        .sellers;

    for (final seller in sellers) {
      widgets.add(
        InkWell(
          onTap: () {
            setState(() {
              Navigator.of(context).pop();
              _seller = seller;
            });
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    seller.brandName,
                    style: AppTheme.textStyle.color100.w500.size(17),
                  ),
                  Radio(
                    activeColor: AppTheme.primaryColor,
                    value: seller,
                    groupValue: _seller,
                    onChanged: (_) {
                      setState(() {
                        Navigator.of(context).pop();
                        _seller = seller;
                      });
                    },
                  )
                ],
              ),
              Divider(
                color: AppTheme.dividerColor,
                thickness: 1,
              )
            ],
          ),
        ),
      );
    }
    BotigaBottomModal(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Seller',
            style: AppTheme.textStyle.color100.w700.size(22),
          ),
          SizedBox(height: 20),
          SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.40,
              child: ListView(
                children: [...widgets],
              ),
            ),
          )
        ],
      ),
      isDismissible: true,
    ).show(context);
  }
}
