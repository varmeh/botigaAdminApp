import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../util/index.dart';
import '../../../models/index.dart' show SellerApartmentModel;
import '../../../widgets/index.dart' show BotigaSwitch;

class ApartmentTile extends StatefulWidget {
  final SellerApartmentModel apartment;
  final Function changeApartmentStatusFunction;
  final Function removeApartmentFunction;

  ApartmentTile({
    @required this.apartment,
    @required this.changeApartmentStatusFunction,
    @required this.removeApartmentFunction,
  });

  @override
  _ApartmentTileState createState() => _ApartmentTileState();
}

class _ApartmentTileState extends State<ApartmentTile> {
  bool _switchValue;

  @override
  void initState() {
    super.initState();
    _switchValue = widget.apartment.live;
  }

  @override
  Widget build(BuildContext context) {
    final _hasSlot = widget.apartment.deliverySlot != null &&
        widget.apartment.deliverySlot.isNotEmpty;

    final _sizedBox16 = SizedBox(height: 16);

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.apartment.name,
                      style: AppTheme.textStyle.w500
                          .size(15)
                          .lineHeight(1.33)
                          .color100,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      widget.apartment.area,
                      style: AppTheme.textStyle
                          .size(15)
                          .w500
                          .color50
                          .lineHeight(1.33),
                    ),
                  ],
                ),
              ),
              BotigaSwitch(
                onChange: (bool value) {
                  this._changeApartmentLiveStatus(value);
                },
                switchValue: _switchValue,
                alignment: Alignment.topRight,
              ),
            ],
          ),
          _sizedBox16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.apartment.deliveryMessage,
                      style: AppTheme.textStyle
                          .size(15)
                          .w500
                          .color50
                          .lineHeight(1.33),
                    ),
                    SizedBox(height: 4.0),
                    _hasSlot
                        ? Text(
                            widget.apartment.deliverySlot,
                            style: AppTheme.textStyle
                                .size(15)
                                .w500
                                .color50
                                .lineHeight(1.33),
                          )
                        : Container(),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Remove Apartment',
                        style: AppTheme.textStyle.w500.color100,
                      ),
                      content: Text(
                        'Are you sure you want to remove this apartment?',
                        style: AppTheme.textStyle.w400.color100,
                      ),
                      actions: [
                        FlatButton(
                          child: Text(
                            'Confirm',
                            style: AppTheme.textStyle.w600
                                .colored(AppTheme.errorColor),
                          ),
                          onPressed: () async {
                            widget.removeApartmentFunction(widget.apartment.id);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'REMOVE',
                  style: AppTheme.textStyle
                      .size(15)
                      .w600
                      .colored(AppTheme.errorColor)
                      .lineHeight(1.33),
                ),
              ),
            ],
          ),
          _sizedBox16,
          Divider(
            color: AppTheme.dividerColor,
            thickness: 1.2,
          ),
        ],
      ),
    );
  }

  void _changeApartmentLiveStatus(bool value) {
    setState(() => _switchValue = value);
    widget.changeApartmentStatusFunction(widget.apartment.id, value, () {
      setState(() {
        _switchValue = !value;
      });
    });
  }
}
