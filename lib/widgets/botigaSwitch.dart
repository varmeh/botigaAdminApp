import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/index.dart';

class BotigaSwitch extends StatelessWidget {
  final bool switchValue;
  final Function onChange;
  final double scale;
  final Alignment alignment;

  BotigaSwitch({
    @required this.switchValue,
    @required this.onChange,
    this.scale = 0.75,
    this.alignment = Alignment.centerRight,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      alignment: this.alignment,
      scale: this.scale,
      child: CupertinoSwitch(
        activeColor: AppTheme.primaryColor,
        value: this.switchValue,
        onChanged: (bool value) {
          this.onChange(value);
        },
      ),
    );
  }
}
