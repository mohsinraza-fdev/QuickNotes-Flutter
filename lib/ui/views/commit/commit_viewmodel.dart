import 'package:flutter/services.dart';
import 'package:quicknotes/services/app_firebase_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.router.dart';
import '../../../app/locator.dart';
import '../../../services/misc_service.dart';
import '../../../services/storage_service.dart';

class CommitViewModel extends BaseViewModel {
  final _storageService = locator<StorageService>();
  final _miscService = locator<MiscService>();
  final _navigator = locator<NavigationService>();
  final _fbService = locator<AppFirebaseService>();

  bool checking1 = false;
  bool checking2 = false;
  bool checking3 = false;

  goOffline() async {
    checking1 = true;
    notifyListeners();
    _miscService.saveDataOnline = false;
    await _storageService.loadDataLocal();
    checking1 = false;
    _navigator.clearStackAndShow(Routes.wrapper);
  }

  commitToCloud() async {
    checking2 = true;
    notifyListeners();
    _miscService.saveDataOnline = true;
    await _fbService.saveDataCloud();
    await _storageService.loadDataLocal();
    checking2 = false;
    _navigator.clearStackAndShow(Routes.wrapper);
  }

  getFromCloud() async {
    checking3 = true;
    notifyListeners();
    await _fbService.loadDataCloud();
    await _storageService.saveDataLocal();
    checking3 = false;
    _navigator.clearStackAndShow(Routes.wrapper);
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
