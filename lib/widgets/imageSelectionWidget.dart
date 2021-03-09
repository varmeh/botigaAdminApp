import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../util/index.dart';
import 'toast.dart';

class ImageSelectionWidget {
  final double width;
  final double height;
  final Function(File) onImageSelection;

  ImageSelectionWidget({
    @required this.width,
    @required this.height,
    @required this.onImageSelection,
  });

  void show(BuildContext context) async {
    try {
      PickedFile pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: width,
        maxHeight: height,
        imageQuality: 100,
      );
      if (pickedFile != null) {
        onImageSelection(File(pickedFile.path));
      }
    } catch (e) {
      if (e.code != null && (e.code == 'photo_access_denied')) {
        _showSettingsDialog(context);
      } else {
        Toast(message: 'Unexpected error').show(context);
      }
    }
  }

  void _showSettingsDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Access Denied',
          style: AppTheme.textStyle.w500.color100,
        ),
        content: Text(
          'To access gallery, enable it in your app settings',
          style: AppTheme.textStyle.w400.color100,
        ),
        actions: [
          FlatButton(
            child: Text(
              'Cancel',
              style: AppTheme.textStyle.w600.color50,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(
              'Settings',
              style: AppTheme.textStyle.w600.colored(AppTheme.primaryColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              AppSettings.openAppSettings();
            },
          ),
        ],
      ),
    );
  }
}
