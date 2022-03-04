import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quicknotes/services/app_firebase_service.dart';
import 'package:quicknotes/services/misc_service.dart';
import 'package:stacked/stacked.dart';

import '../../../app/locator.dart';

class LoginFormViewModel extends FormViewModel {
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
    _miscService.showLoadingMessage = 'Verifying';
    _miscService.showLoadingScreen = true;
    if (!(_email.contains('@') && _email.contains('.com'))) {
      setValidationMessage('Please enter a valid email address');
      emailError = true;
    } else if (_password == '') {
      setValidationMessage('Password field is empty');
      passwordError = true;
    } else {
      try {
        await _fbService.login(email: _email, password: _password);
      } on FirebaseException catch (e) {
        if (e.message.toString().startsWith('There is no user record')) {
          setValidationMessage('User with this email address does not exist');
        } else if (e.message.toString().startsWith('com.google.firebase')) {
          setValidationMessage(
              'Oops! Something went wrong\nplease check your internet connection');
        } else {
          setValidationMessage(e.message.toString());
        }
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
