import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quicknotes/app/colors.dart';
import 'package:quicknotes/ui/views/confirmation/confirmation_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ConfirmationView extends StatelessWidget {
  const ConfirmationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ViewModelBuilder<ConfirmationViewModel>.nonReactive(
        viewModelBuilder: () => ConfirmationViewModel(),
        onDispose: (viewModel) => viewModel.disposeScreen(),
        builder: (context, model, child) => Scaffold(
              body: Container(
                width: size.width,
                height: size.height,
                color: AppColors.primaryDark,
                child: Stack(
                  children: [
                    Positioned(
                      top: 70,
                      right: 20,
                      left: 20,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Oops! Guess your device is not connected to internet',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'You can continue in offline mode and commit changes later.',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    OfflineButton(),
                    RetryButton(),
                  ],
                ),
              ),
            ));
  }
}

class OfflineButton extends ViewModelWidget<ConfirmationViewModel> {
  const OfflineButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ConfirmationViewModel viewModel) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: GestureDetector(
        onTap: () {
          if (viewModel.checking1 || viewModel.checking2) {
          } else {
            viewModel.goOffline();
          }
        },
        child: Container(
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.5))
              ]),
          child: viewModel.checking2
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Text(
                  'Continue Offline',
                  style: TextStyle(
                      color: AppColors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
        ),
      ),
    );
  }
}

class RetryButton extends ViewModelWidget<ConfirmationViewModel> {
  const RetryButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ConfirmationViewModel viewModel) {
    return Positioned(
      bottom: 100,
      left: 20,
      right: 20,
      child: GestureDetector(
        onTap: () {
          if (viewModel.checking1 || viewModel.checking2) {
          } else {
            viewModel.retry();
          }
        },
        child: Container(
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.5))
              ]),
          child: viewModel.checking1
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Text(
                  'Retry',
                  style: TextStyle(
                      color: AppColors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
        ),
      ),
    );
  }
}
