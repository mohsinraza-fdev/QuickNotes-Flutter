import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class MiscService with ReactiveServiceMixin {
  //Loading Screen Indicator
  ReactiveValue<bool> _showLoadingScreen = ReactiveValue<bool>(true);
  bool get showLoadingScreen => _showLoadingScreen.value;
  set showLoadingScreen(value) {
    _showLoadingScreen.value = value;
  }

  ReactiveValue<String> _showLoadingMessage = ReactiveValue<String>('');
  String get showLoadingMessage => _showLoadingMessage.value;
  set showLoadingMessage(value) {
    _showLoadingMessage.value = value;
  }

  bool newlyRegistered = false;
  int selectedNoteIndex = 0;
  bool saveDataOnline = true;

  MiscService() {
    listenToReactiveValues([_showLoadingScreen, _showLoadingMessage]);
  }
}
