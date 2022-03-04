import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:quicknotes/app/locator.dart';
import 'package:quicknotes/models/user_model.dart';
import 'package:quicknotes/services/app_firebase_service.dart';
import 'package:quicknotes/services/misc_service.dart';
import 'package:quicknotes/services/storage_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.router.dart';

class WrapperViewModel extends BaseViewModel {
  final _storageService = locator<StorageService>();
  final _fbService = locator<AppFirebaseService>();
  final _miscService = locator<MiscService>();
  final _navigator = locator<NavigationService>();

  AppUser? get user => _storageService.user;

  //final _miscService = locator<MiscService>();

  bool _userNullVerified = false;
  bool get userNullVerified => _userNullVerified;
  set userNullVerified(value) {
    _userNullVerified = value;
  }

  void verifyUserNull() async {
    _miscService.showLoadingMessage = 'Loading';
    if (user == null) {
      //load data from local storage
      await _storageService.loadDataLocal();
      if (user != null) {
        var onlineWith = await (Connectivity().checkConnectivity());
        if (onlineWith == ConnectivityResult.mobile ||
            onlineWith == ConnectivityResult.wifi) {
          try {
            _miscService.showLoadingMessage = 'Connecting';

            final result = await InternetAddress.lookup('example.com')
                .timeout(Duration(seconds: 2));
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              bool change = await _storageService.getChanges();
              if (change) {
                _navigator.clearStackAndShow(Routes.commitView);
              } else {
                _miscService.showLoadingMessage = 'Retrieving Data';
                await _fbService.loadDataCloud();
                _navigator.clearStackAndShow(Routes.wrapper);
              }
            }
          } catch (e) {
            _navigator.clearStackAndShow(Routes.confirmationView);
          }
        } else {
          _navigator.clearStackAndShow(Routes.confirmationView);
        }
      } else {
        _miscService.showLoadingScreen = false;
        userNullVerified = true;
        notifyListeners();
      }
    } else {
      _miscService.showLoadingScreen = false;
      userNullVerified = true;
      notifyListeners();
    }
  }
}
