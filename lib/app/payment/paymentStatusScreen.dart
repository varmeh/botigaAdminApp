import 'package:flutter/material.dart';

import '../../util/index.dart' show AppTheme, TextStyleHelpers;
import '../../widgets/index.dart'
    show BotigaAppBar, BotigaTextFieldForm, CallButton, WhatsappButton;
import '../../models/index.dart' show SellerModel;

import '../tabbar.dart';

class PaymentStatusScreen extends StatelessWidget {
  final SellerModel seller;
  final String status;
  final String txnId;
  final String txnAmount;

  PaymentStatusScreen({
    @required this.seller,
    @required this.status,
    @required this.txnId,
    @required this.txnAmount,
  });

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 16);
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: BotigaAppBar('Transaction Status'),
      floatingActionButton: _homeButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BotigaTextFieldForm(
                focusNode: null,
                labelText: 'seller',
                onSave: null,
                initialValue: seller.brand,
                readOnly: true,
              ),
              sizedBox,
              BotigaTextFieldForm(
                focusNode: null,
                labelText: 'Txn Status',
                onSave: null,
                initialValue: status,
                readOnly: true,
              ),
              sizedBox,
              BotigaTextFieldForm(
                focusNode: null,
                labelText: 'Txn Id',
                onSave: null,
                initialValue: txnId,
                readOnly: true,
              ),
              sizedBox,
              BotigaTextFieldForm(
                focusNode: null,
                labelText: 'Txn Amount',
                onSave: null,
                initialValue: txnAmount,
                readOnly: true,
              ),
              SizedBox(height: 48),
              status == 'TXN_SUCCESS'
                  ? Row(
                      children: [
                        Expanded(
                          child: CallButton(number: seller.phone),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: WhatsappButton(
                            number: seller.whatsapp,
                            message:
                                'Team Botiga has successfully done a test transaction of amount $txnAmount to your account.\nTransactionId for this transaction is $txnId.\nPlease confirm once money is credited to your account.\nOnly then, we would enable your account for community activations.\nThank you',
                          ),
                        ),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _homeButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      width: 90,
      height: 120,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xff121714).withOpacity(0.12),
            blurRadius: 40.0, // soften the shadow
            spreadRadius: 0.0, //extend the shadow
            offset: Offset(
              0.0, // Move to right 10  horizontally
              0.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => Tabbar(index: 0),
              transitionDuration: Duration.zero,
            ),
            (route) => false,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.home,
                color: AppTheme.color50,
                size: 44,
              ),
              SizedBox(height: 4.0),
              Text(
                'Home',
                textAlign: TextAlign.center,
                style: AppTheme.textStyle
                    .colored(AppTheme.color100)
                    .w500
                    .size(12)
                    .letterSpace(0.3),
              )
            ],
          ),
        ),
      ),
    );
  }
}
