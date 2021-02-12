import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:provider/provider.dart';

import '../../util/index.dart' show AppTheme, Http, TextStyleHelpers;
import '../../widgets/index.dart'
    show
        BotigaTextFieldForm,
        ActiveButton,
        PassiveButton,
        LoaderOverlay,
        BotigaSwitch,
        Toast,
        BotigaBottomModal;

import '../../provider/index.dart' show SellerProvider;

import '../../models/index.dart' show SellerModel;

import './store/storeScreen.dart';
import './apartment/apartmentScreen.dart';
import 'paymentStatusScreen.dart';

class SellerScreen extends StatefulWidget {
  @override
  _SellerScreenState createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  final _divider = Padding(
    padding: const EdgeInsets.symmetric(vertical: 32.0),
    child: Divider(
      thickness: 8.0,
      color: AppTheme.dividerColor,
    ),
  );

  GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _paytmMidFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _testPaymentFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _updatedMid;
  String _amount;
  TextEditingController _midTextEditingController;

  final _razorpay = Razorpay();

  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+91 ##### #####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();

    _midTextEditingController = TextEditingController();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _showPaymentStatus(true, response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _showPaymentStatus(false, 'NA');
  }

  Future<void> _showPaymentStatus(bool status, String txnId) async {
    setState(() => _isLoading = false);

    final provider = Provider.of<SellerProvider>(context, listen: false);

    if (status) {
      await provider.notifySellerOfSuccessfulTestTransaction(_amount, txnId);
    }

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => PaymentStatusScreen(
          seller: provider.seller,
          status: status,
          txnAmount: _amount,
          txnId: txnId,
        ),
        transitionDuration: Duration.zero,
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _midTextEditingController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SellerProvider>(context, listen: false);

    return LoaderOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        floatingActionButton: _getSellerDetails(context, provider),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                _sellerDetails(provider.seller),
                provider.hasSeller ? _divider : Container(),
                _fssaiDetails(provider.seller),
                provider.hasSeller ? _divider : Container(),
                _bankDetails(provider.seller),
                SizedBox(height: 152),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sellerDetails(SellerModel seller) {
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
                  labelText: 'Business Type',
                  onSave: null,
                  initialValue: seller.businessType,
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
                  labelText: 'GSTIN',
                  onSave: null,
                  initialValue: seller.gstin,
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
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ActiveButton(
                        title: 'Apartments',
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ApartmentScreen(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: ActiveButton(
                        title: 'Store',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StoreScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }

  Widget _fssaiDetails(SellerModel seller) {
    const sizedBox = SizedBox(height: 16);
    return seller == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fssai Details',
                  textAlign: TextAlign.start,
                  style: AppTheme.textStyle.color100.w500.size(18.0),
                ),
                SizedBox(height: 24),
                BotigaTextFieldForm(
                  focusNode: null,
                  labelText: 'Number',
                  onSave: null,
                  initialValue: seller.fssaiNumber ?? '',
                  readOnly: true,
                ),
                sizedBox,
                BotigaTextFieldForm(
                  focusNode: null,
                  labelText: 'Validity Date',
                  onSave: null,
                  initialValue: seller.fssaiValidityDate != null
                      ? seller.fssaiValidityDate.toLocal().toString()
                      : '',
                  readOnly: true,
                ),
                sizedBox,
                BotigaTextFieldForm(
                  focusNode: null,
                  labelText: 'Certificate Url',
                  onSave: null,
                  initialValue: seller.fssaiCertificateUrl ?? '',
                  readOnly: true,
                ),
              ],
            ),
          );
  }

  Widget _bankDetails(SellerModel seller) {
    const sizedBox = SizedBox(height: 16);

    _midTextEditingController.text = seller == null ? '' : seller.mid;

    return seller == null
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
                  initialValue: seller?.beneficiaryName,
                  readOnly: true,
                ),
                sizedBox,
                BotigaTextFieldForm(
                  focusNode: null,
                  labelText: 'Account Number',
                  onSave: null,
                  initialValue: seller?.accountNumber,
                  readOnly: true,
                ),
                sizedBox,
                BotigaTextFieldForm(
                  focusNode: null,
                  labelText: 'IFSC',
                  onSave: null,
                  initialValue: seller?.ifscCode,
                  readOnly: true,
                ),
                sizedBox,
                BotigaTextFieldForm(
                  focusNode: null,
                  labelText: 'Bank',
                  onSave: null,
                  initialValue: seller?.bankName,
                  readOnly: true,
                ),
                sizedBox,
                BotigaTextFieldForm(
                  focusNode: null,
                  labelText: 'Account Type',
                  onSave: null,
                  initialValue: seller?.accountType,
                  readOnly: true,
                ),
                sizedBox,
                BotigaTextFieldForm(
                  focusNode: null,
                  labelText: 'Merchant MID',
                  onSave: null,
                  readOnly: true,
                  textEditingController: _midTextEditingController,
                ),
                sizedBox,
                _switchDetails(
                  title: 'Authorize Bank Details Update',
                  subTitle: 'Permission Necessary for Bank Update',
                  initialValue: seller?.editable ?? false,
                  onChange: (bool val) => _toggleEditable(val),
                  confirmationMessage:
                      'Are you sure you want to make account editable',
                ),
                _switchDetails(
                  title: 'Seller Account Verified',
                  subTitle: 'Seller can\'t go live unless verified',
                  initialValue: seller?.verified ?? false,
                  onChange: (bool val) => _toggleVerified(val),
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
                        onPressed: () => _testPaymentModal().show(context),
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
        onChange: onChange,
        switchValue: initialValue,
        alignment: Alignment.topRight,
      ),
    );
  }

  Widget _getSellerDetails(BuildContext context, SellerProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10.0,
        left: 20.0,
        right: 20.0,
      ),
      child: provider.hasSeller
          ? Padding(
              padding: EdgeInsets.only(bottom: 28.0),
              child: FloatingActionButton.extended(
                backgroundColor: AppTheme.backgroundColor,
                elevation: 4.0,
                icon: const Icon(Icons.logout, color: Color(0xff179F57)),
                label: Text(
                  'Change Seller',
                  style: AppTheme.textStyle
                      .size(15)
                      .w700
                      .letterSpace(1)
                      .colored(AppTheme.primaryColor),
                ),
                onPressed: () {
                  provider.removeSeller();
                  _phoneMaskFormatter.clear();
                  setState(() {});
                },
              ),
            )
          : Form(
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
            ),
    );
  }

  BotigaBottomModal _patymMidModal() {
    const sizedBox24 = SizedBox(height: 24);
    final provider = Provider.of<SellerProvider>(context, listen: false);

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
              labelText: 'Merchant MID',
              onSave: (String val) => _updatedMid = val,
              onFieldSubmitted: (String val) => _updatedMid = val,
              validator: (val) {
                if (val.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              initialValue: provider.seller.mid,
            ),
          ),
          sizedBox24,
          ActiveButton(
            title: 'Update',
            onPressed: () async {
              if (_paytmMidFormKey.currentState.validate()) {
                _paytmMidFormKey.currentState.save();
                setState(() => _isLoading = true);
                try {
                  await Provider.of<SellerProvider>(context, listen: false)
                      .updateMid(_updatedMid);

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

  BotigaBottomModal _testPaymentModal() {
    const sizedBox24 = SizedBox(height: 24);
    final provider = Provider.of<SellerProvider>(context, listen: false);

    return BotigaBottomModal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Verify Seller Bank Account',
            style: AppTheme.textStyle.w700.color100.size(20.0).lineHeight(1.25),
          ),
          sizedBox24,
          Text(
            'Confirm Seller account before activation. Make a small test transaction',
            style: AppTheme.textStyle.w500.color50.size(14.0).lineHeight(1.25),
          ),
          sizedBox24,
          Form(
            key: _testPaymentFormKey,
            child: BotigaTextFieldForm(
              focusNode: null,
              labelText: 'Amount',
              onSave: (String val) => _amount = val,
              onFieldSubmitted: (String val) => _amount = val,
              keyboardType: TextInputType.datetime,
              validator: (val) => val.isEmpty ? 'Required' : null,
            ),
          ),
          sizedBox24,
          ActiveButton(
            title: 'Continue',
            onPressed: () async {
              if (_testPaymentFormKey.currentState.validate()) {
                _testPaymentFormKey.currentState.save();
                setState(() => _isLoading = true);
                try {
                  final orderId =
                      await Provider.of<SellerProvider>(context, listen: false)
                          .getTestOrderId(_amount);

                  final options = {
                    'key': 'rzp_live_U6Hf0upRNgYgtc',
                    'amount': double.parse(_amount) * 100,
                    'name': provider.seller.brand,
                    'order_id': orderId,
                    'timeout': 60 * 3, // In secs,
                    'prefill': {
                      'contact': provider.seller.phone,
                      'email': provider.seller.email,
                      'method': 'upi',
                    },
                  };
                  _razorpay.open(options);
                } catch (error) {
                  setState(() => _isLoading = false);
                  Toast(
                    message: 'Payment failed. Try again',
                    color: AppTheme.errorColor,
                  ).show(context);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onSubmitted(BuildContext context) async {
    if (_phoneFormKey.currentState.validate()) {
      _phoneFormKey.currentState.save();
      // Fetch seller info
      setState(() => _isLoading = true);
      try {
        final provider = Provider.of<SellerProvider>(context, listen: false);
        await provider.getSeller(_phoneMaskFormatter.getUnmaskedText());
        _midTextEditingController.text = provider.seller.mid;
      } catch (error) {
        Toast(message: Http.message(error)).show(context);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleEditable(bool value) async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<SellerProvider>(context, listen: false)
          .bankDetailsEditable(value);
      Toast(message: 'Bank Details Editable').show(context);
    } catch (error) {
      Toast(
        message: 'Update failed. Try again',
        color: AppTheme.errorColor,
      ).show(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleVerified(bool value) async {
    setState(() => _isLoading = true);

    try {
      await Provider.of<SellerProvider>(context, listen: false)
          .bankDetailsVerified(value);
      Toast(message: 'Bank Details Verified').show(context);
    } catch (error) {
      Toast(
        message: 'Update failed. Try again',
        color: AppTheme.errorColor,
      ).show(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
