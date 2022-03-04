import 'package:quicknotes/services/misc_service.dart';
import 'package:stacked/stacked.dart';

import '../../../app/locator.dart';

class LoadingScreenViewModel extends ReactiveViewModel {
  final _miscService = locator<MiscService>();

  bool get showLoading => _miscService.showLoadingScreen;
  String get showMessage => _miscService.showLoadingMessage;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_miscService];
}
