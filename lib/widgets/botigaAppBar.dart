import 'package:flutter/material.dart';

import '../util/index.dart';

class BotigaAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final double titlePadding;
  final List<Widget> actions;
  final bool canPop;

  BotigaAppBar(
    this.title, {
    Key key,
    this.actions,
    this.titlePadding = 20.0,
    this.canPop = true,
  })  : preferredSize = Size.fromHeight(56.0), //setting to default height
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasBackButton = canPop && Navigator.canPop(context);

    if (hasBackButton) {
      return AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
        automaticallyImplyLeading: hasBackButton,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppTheme.color100,
          ),
        ),
        title: Text(
          title,
          style: AppTheme.textStyle.w600.color100.size(20).lineHeight(1.25),
        ),
        backgroundColor: AppTheme.backgroundColor,
        brightness: Brightness.light,
        elevation: 0.0,
        actions: actions,
      );
    }
    return AppBar(
      centerTitle: false,
      titleSpacing: titlePadding,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: AppTheme.textStyle.w600.color100.size(20).lineHeight(1.25),
      ),
      backgroundColor: AppTheme.backgroundColor,
      brightness: Brightness.light,
      elevation: 0.0,
      actions: actions,
    );
  }
}
