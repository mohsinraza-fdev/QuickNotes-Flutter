import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quicknotes/ui/views/authentication/login_form_view.dart';
import 'package:quicknotes/ui/views/authentication/signup_form_view.dart';
import 'package:quicknotes/ui/views/loading_screen/loading_screen_view.dart';
import 'package:stacked/stacked.dart';
import '../../../app/colors.dart';
import 'authentication_viewmodel.dart';

class AuthenticationView extends StatelessWidget {
  const AuthenticationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width > size.height ? size.height : size.width;
    double height = size.width > size.height ? size.width : size.height;
    double mainWidth = width - 80 > 400 ? 400 : width - 80;

    return ViewModelBuilder<AuthenticationViewModel>.nonReactive(
      viewModelBuilder: () => AuthenticationViewModel(),
      builder: (context, model, child) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                width: size.width,
                height: size.height,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [AppColors.primaryDark, AppColors.green],
                  ),
                  //color: Theme.of(context).primaryColor,
                ),
                child: SingleChildScrollView(
                  child: Container(
                    width: size.width,
                    child: Container(
                      width: width,
                      height: height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            padding: EdgeInsets.all(30),
                            width: 210,
                            height: 210,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: SvgPicture.asset(
                                'images/logo.svg',
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ),
                          Container(
                            width: mainWidth,
                            height: 330,
                            decoration: BoxDecoration(
                                color: AppColors.primaryDark.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(25)),
                            child: Column(
                              children: [
                                LoginSignUpButtons(),
                                AnimatedFormPreviews(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              LoadingScreen()
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedFormPreviews extends ViewModelWidget<AuthenticationViewModel> {
  const AnimatedFormPreviews({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, AuthenticationViewModel viewModel) {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 150),
        child: viewModel.selectedAuthenticationButton == 1
            ? LoginForm()
            : SignupForm());
  }
}

class LoginSignUpButtons extends ViewModelWidget<AuthenticationViewModel> {
  const LoginSignUpButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, AuthenticationViewModel viewModel) {
    Size size = MediaQuery.of(context).size;
    double width = size.width > size.height ? size.height : size.width;
    double mainWidth = width - 80 > 400 ? 400 : width - 80;

    return Container(
      width: mainWidth,
      height: 60,
      color: Colors.transparent,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 150),
            bottom: 0,
            left:
                viewModel.selectedAuthenticationButton == 1 ? 0 : mainWidth / 2,
            child: Container(
              height: 5,
              width: mainWidth / 2,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(45)),
              ),
            ),
          ),
          AppTextButton(
            width: mainWidth,
            text: 'Login',
            left: 0,
            right: null,
            buttoncode: 1,
          ),
          AppTextButton(
            width: mainWidth,
            text: 'Sign up',
            left: null,
            right: 0,
            buttoncode: 2,
          ),
        ],
      ),
    );
  }
}

class AppTextButton extends ViewModelWidget<AuthenticationViewModel> {
  const AppTextButton({
    Key? key,
    required this.width,
    required this.text,
    required this.left,
    required this.right,
    required this.buttoncode,
  }) : super(key: key);

  final double width;
  final String text;
  final double? left;
  final double? right;
  final int buttoncode;

  @override
  Widget build(BuildContext context, AuthenticationViewModel viewModel) {
    return Positioned(
      left: left,
      right: right,
      child: GestureDetector(
        onTap: () => viewModel.selectedAuthenticationButton = buttoncode,
        child: Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          width: width / 2,
          height: 60,
          child: Text(text,
              style: viewModel.selectedAuthenticationButton == buttoncode
                  ? TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 20.5,
                      fontWeight: FontWeight.w500)
                  : TextStyle(
                      color: AppColors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.normal)),
        ),
      ),
    );
  }
}
