import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:quicknotes/app/locator.dart';
import 'package:quicknotes/services/misc_service.dart';
import 'package:quicknotes/services/storage_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.router.dart';

class ConfirmationViewModel extends BaseViewModel {
  final _storageService = locator<StorageService>();
  final _miscService = locator<MiscService>();
  final _navigator = locator<NavigationService>();

  bool checking1 = false;
  bool checking2 = false;

  goOffline() async {
    checking2 = true;
    notifyListeners();
    _miscService.saveDataOnline = false;
    await _storageService.loadDataLocal();
    checking2 = false;
    _navigator.clearStackAndShow(Routes.wrapper);
  }

  retry() async {
    checking1 = true;
    notifyListeners();
    var onlineWith = await (Connectivity().checkConnectivity());
    if (onlineWith == ConnectivityResult.mobile ||
        onlineWith == ConnectivityResult.wifi) {
      try {
        final result = await InternetAddress.lookup('example.com')
            .timeout(Duration(seconds: 2));
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          checking1 = false;
          _storageService.user = null;
          _navigator.clearStackAndShow(Routes.wrapper);
        }
      } catch (e) {}
    }
    checking1 = false;
    notifyListeners();
  }

  disposeScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
