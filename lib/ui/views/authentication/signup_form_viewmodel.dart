import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:quicknotes/services/app_firebase_service.dart';
import 'package:quicknotes/services/misc_service.dart';
import 'package:stacked/stacked.dart';

import '../../../app/locator.dart';

class SignupFormViewModel extends FormViewModel {
  //Service Locators
  final _miscService = locator<MiscService>();
  final _fbService = locator<AppFirebaseService>();

  //Service Getters
  bool get showLoadingScreen => _miscService.showLoadingScreen;

  //Local Model attributes and methods

  String get _email => formValueMap['email'] ?? '';
  String get _password => formValueMap['password'] ?? '';

  bool _emailError = false;
  bool get emailError => _emailError;
  set emailError(value) {
    _emailError = value;
    notifyListeners();
  }

  bool _passwordError = false;
  bool get passwordError => _passwordError;
  set passwordError(value) {
    _passwordError = value;
    notifyListeners();
  }

  void sendForValidation() async {
    setValidationMessage(null);
    emailError = false;
    passwordError = false;
    notifyListeners();
    _miscService.showLoadingMessage = 'Processing';
    _miscService.showLoadingScreen = true;
    if (!(_email.contains('@') && _email.contains('.com'))) {
      setValidationMessage('Please enter a valid email address');
      emailError = true;
    } else if (_password == '') {
      setValidationMessage('Password field cannot be empty');
      passwordError = true;
    } else if (_password.length < 8) {
      setValidationMessage('Password must be atleast 8 characters long');
      passwordError = true;
    } else {
      try {
        await _fbService.register(email: _email, password: _password);
      } on FirebaseException catch (e) {
        setValidationMessage(e.message.toString());
        notifyListeners();
      }
    }
    _miscService.showLoadingMessage = '';
    _miscService.showLoadingScreen = false;
  }

  bool _submitButtonTouched = false;
  bool get submitButtonTouched => _submitButtonTouched;
  set submitButtonTouched(value) {
    _submitButtonTouched = value;
    notifyListeners();
  }

  @override
  void setFormStatus() {}
}
