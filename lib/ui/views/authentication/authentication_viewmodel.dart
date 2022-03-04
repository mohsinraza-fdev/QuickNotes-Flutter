import 'package:stacked/stacked.dart';

class AuthenticationViewModel extends BaseViewModel {
  //Authentication Button Selection Variables
  int _selectedAuthenticationButton = 1;
  int get selectedAuthenticationButton => _selectedAuthenticationButton;
  set selectedAuthenticationButton(value) {
    _selectedAuthenticationButton = value;
    notifyListeners();
  }
}
