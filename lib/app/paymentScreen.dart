import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../util/index.dart' show AppTheme, Http;
import '../widgets/index.dart'
    show BotigaTextFieldForm, ActiveButton, BotigaAppBar, LoaderOverlay, Toast;

import '../models/index.dart' show SellerModel;

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  SellerModel seller;

  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+91 ##### #####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        floatingActionButton: _getSellerDetails(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: BotigaAppBar('Seller Payment Configuration'),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  _sellerDetails(),
                  _bankDetails(),
                  SizedBox(height: 152),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sellerDetails() {
    const sizedBox = SizedBox(height: 16);
    return seller == null
        ? Container()
        : Column(
            children: [
              BotigaTextFieldForm(
                focusNode: null,
                labelText: 'Business Name',
                onSave: null,
                initialValue: seller.businessName,
                readOnly: true,
              ),
              sizedBox,
              BotigaTextFieldForm(
                focusNode: null,
                labelText: 'Category',
                onSave: null,
                initialValue: seller.businessCategory,
                readOnly: true,
              ),
              sizedBox,
              BotigaTextFieldForm(
                focusNode: null,
                labelText: 'Brand',
                onSave: null,
                initialValue: seller.brand,
                readOnly: true,
              ),
              sizedBox,
              BotigaTextFieldForm(
                focusNode: null,
                labelText: 'Tag Line',
                onSave: null,
                initialValue: seller.tagline,
                readOnly: true,
              ),
              sizedBox,
              BotigaTextFieldForm(
                focusNode: null,
                labelText: 'Phone',
                onSave: null,
                initialValue: seller.phone,
                readOnly: true,
              ),
              sizedBox,
              BotigaTextFieldForm(
                focusNode: null,
                labelText: 'Whatsapp',
                onSave: null,
                initialValue: seller.whatsapp,
                readOnly: true,
              ),
              sizedBox,
              BotigaTextFieldForm(
                focusNode: null,
                labelText: 'Email',
                onSave: null,
                initialValue: seller.email,
                readOnly: true,
              ),
              sizedBox,
            ],
          );
  }

  Widget _bankDetails() {
    const sizedBox = SizedBox(height: 16);
    return seller == null || seller.beneficiaryName == null
        ? Container()
        : Column(
            children: [
              BotigaTextFieldForm(
                focusNode: null,
                labelText: 'Beneficiary Name',
                onSave: null,
                initialValue: seller.beneficiaryName,
                readOnly: true,
              ),
              sizedBox,
              BotigaTextFieldForm(
                focusNode: null,
                labelText: 'Account Number',
                onSave: null,
                initialValue: seller.accountNumber,
                readOnly: true,
              ),
              sizedBox,
              BotigaTextFieldForm(
                focusNode: null,
                labelText: 'IFSC',
                onSave: null,
                initialValue: seller.ifscCode,
                readOnly: true,
              ),
              sizedBox,
              BotigaTextFieldForm(
                focusNode: null,
                labelText: 'Bank',
                onSave: null,
                initialValue: seller.bankName,
                readOnly: true,
              ),
              sizedBox,
              BotigaTextFieldForm(
                focusNode: null,
                labelText: 'Account Type',
                onSave: null,
                initialValue: seller.accountType,
                readOnly: true,
              ),
              sizedBox,
            ],
          );
  }

  Widget _getSellerDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10.0,
        left: 20.0,
        right: 20.0,
      ),
      child: seller == null
          ? Form(
              key: _phoneFormKey,
              child: BotigaTextFieldForm(
                focusNode: null,
                labelText: 'Seller Phone Number',
                onSave: (_) {},
                keyboardType: TextInputType.datetime,
                onFieldSubmitted: (_) => _onSubmitted(context),
                validator: (val) {
                  if (_phoneMaskFormatter.getUnmaskedText().isEmpty) {
                    return 'Required';
                  } else if (_phoneMaskFormatter.getUnmaskedText().length !=
                      10) {
                    return 'Please provide a valid 10 digit Mobile Number';
                  }
                  return null;
                },
                maskFormatter: _phoneMaskFormatter,
              ),
            )
          : ActiveButton(
              title: 'Change Seller',
              width: 200,
              onPressed: () {
                _phoneMaskFormatter.clear();
                setState(() => seller = null);
              },
            ),
    );
  }

  Future<void> _onSubmitted(BuildContext context) async {
    if (_phoneFormKey.currentState.validate()) {
      // Fetch seller info
      setState(() => _isLoading = true);
      try {
        final json = await Http.get(
            '/api/admin/seller/${_phoneMaskFormatter.getUnmaskedText()}');
        seller = SellerModel.fromJson(json);
      } catch (error) {
        Toast(message: Http.message(error)).show(context);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
