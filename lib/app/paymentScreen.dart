import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../util/index.dart' show AppTheme, Http, TextStyleHelpers;
import '../widgets/index.dart'
    show
        BotigaTextFieldForm,
        ActiveButton,
        PassiveButton,
        BotigaAppBar,
        LoaderOverlay,
        BotigaSwitch,
        Toast,
        BotigaBottomModal;

import '../models/index.dart' show SellerModel;

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _paytmMidFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _updatedMid;
  SellerModel seller;
  TextEditingController _midTextEditingController;

  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+91 ##### #####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();

    _midTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _midTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        floatingActionButton: _getSellerDetails(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: BotigaAppBar('Payment Configuration'),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                _sellerDetails(),
                _sellerDoesnotHaveBankDetails()
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: Divider(
                          thickness: 8.0,
                          color: AppTheme.dividerColor,
                        ),
                      ),
                _bankDetails(),
                SizedBox(height: 152),
              ],
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
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seller Details',
                  textAlign: TextAlign.start,
                  style: AppTheme.textStyle.color100.w500.size(18.0),
                ),
                SizedBox(height: 24),
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
              ],
            ),
          );
  }

  Widget _bankDetails() {
    const sizedBox = SizedBox(height: 16);
    return _sellerDoesnotHaveBankDetails()
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bank Details',
                  textAlign: TextAlign.start,
                  style: AppTheme.textStyle.color100.w500.size(18.0),
                ),
                SizedBox(height: 24),
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
                BotigaTextFieldForm(
                  focusNode: null,
                  labelText: 'Paytm MID',
                  onSave: null,
                  readOnly: true,
                  textEditingController: _midTextEditingController,
                ),
                sizedBox,
                _switchDetails(
                  title: 'Authorize Bank Details Update',
                  subTitle: 'Permission Necessary for Bank Update',
                  initialValue: seller.editable,
                  onChange: (bool val) => _toggleStatus('editable', val),
                  confirmationMessage:
                      'Are you sure you want to make account editable',
                ),
                _switchDetails(
                  title: 'Seller Account Verified',
                  subTitle: 'Seller can\'t go live unless verified',
                  initialValue: seller.verified,
                  onChange: (bool val) => _toggleStatus('verified', val),
                  confirmationMessage:
                      'Has seller emailed you the snapshot of test payment?',
                ),
                sizedBox,
                Row(
                  children: [
                    Expanded(
                      child: PassiveButton(
                        title: 'Update MID',
                        onPressed: () => _patymMidModal().show(context),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: PassiveButton(
                        title: 'Test Payment',
                        onPressed: () {},
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }

  Widget _switchDetails({
    String title,
    String subTitle,
    bool initialValue,
    Function onChange,
    String confirmationMessage,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0.0),
      title: Text(
        title,
        style: AppTheme.textStyle.w500.size(16).lineHeight(1.33).color100,
      ),
      subtitle: Text(
        subTitle,
        style: AppTheme.textStyle.w500.size(14).lineHeight(1.33).color50,
      ),
      trailing: BotigaSwitch(
        onChange: (bool value) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Confirmation',
                  style: AppTheme.textStyle.w500.color100,
                ),
                content: Text(
                  confirmationMessage,
                  style: AppTheme.textStyle.w400.color100,
                ),
                actions: [
                  FlatButton(
                    child: Text(
                      'Yes',
                      style: AppTheme.textStyle.w600
                          .colored(AppTheme.primaryColor),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      onChange(value);
                    },
                  ),
                ],
              );
            },
          );
        },
        switchValue: initialValue,
        alignment: Alignment.topRight,
      ),
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

  BotigaBottomModal _patymMidModal() {
    const sizedBox24 = SizedBox(height: 24);

    return BotigaBottomModal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Update MID',
            style: AppTheme.textStyle.w700.color100.size(20.0).lineHeight(1.25),
          ),
          SizedBox(height: 24),
          Form(
            key: _paytmMidFormKey,
            child: BotigaTextFieldForm(
              focusNode: null,
              labelText: 'Paytm MID',
              onSave: (String val) => _updatedMid = val,
              onFieldSubmitted: (String val) => _updatedMid = val,
              validator: (val) {
                if (val.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              initialValue: seller.mid,
            ),
          ),
          sizedBox24,
          ActiveButton(
            title: 'Update',
            onPressed: () async {
              if (_paytmMidFormKey.currentState.validate()) {
                setState(() => _isLoading = true);
                try {
                  final json = await Http.patch(
                    '/api/admin/seller/bankDetails',
                    body: {
                      'phone': seller.phone,
                      'mid': _updatedMid,
                    },
                  );
                  seller = SellerModel.fromJson(json);
                  Navigator.of(context).pop();
                  Toast(message: 'MID updated').show(context);
                  _midTextEditingController.text = _updatedMid;
                } catch (error) {
                  Toast(
                    message: 'Mid update failed. Try again',
                    color: AppTheme.errorColor,
                  ).show(context);
                } finally {
                  setState(() => _isLoading = false);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  bool _sellerDoesnotHaveBankDetails() =>
      seller == null || seller.beneficiaryName == null;

  Future<void> _onSubmitted(BuildContext context) async {
    if (_phoneFormKey.currentState.validate()) {
      // Fetch seller info
      setState(() => _isLoading = true);
      try {
        final json = await Http.get(
            '/api/admin/seller/${_phoneMaskFormatter.getUnmaskedText()}');
        seller = SellerModel.fromJson(json);
        _midTextEditingController.text = seller.mid;
      } catch (error) {
        Toast(message: Http.message(error)).show(context);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleStatus(String field, bool value) async {
    setState(() {
      seller.editable = value;
      _isLoading = true;
    });
    bool _error = false;
    try {
      final json = await Http.patch(
        '/api/admin/seller/bankDetails',
        body: {
          'phone': seller.phone,
          field: value,
        },
      );
      seller = SellerModel.fromJson(json);
      Toast(message: 'Bank Details editable updated').show(context);
    } catch (error) {
      Toast(
        message: 'Update failed. Try again',
        color: AppTheme.errorColor,
      ).show(context);
      _error = true;
    } finally {
      if (_error) {
        seller.editable = !value;
      }
      setState(() {
        _isLoading = false;
      });
    }
  }
}
