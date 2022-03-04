import 'package:flutter/material.dart';
import 'package:quicknotes/app/colors.dart';
import 'package:stacked_services/stacked_services.dart';

import 'locator.dart';

void setupSnackbarUi() {
  final service = locator<SnackbarService>();

  // Registers a config to be used when calling showSnackbar
  service.registerSnackbarConfig(SnackbarConfig(
    backgroundColor: Colors.white,
    textColor: AppColors.primaryDark,
    titleColor: AppColors.green,
    messageText: null,
    titleText: null,
    borderRadius: 2,
    margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
  ));
}
