import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quicknotes/ui/views/confirmation/confirmation_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../../app/colors.dart';
import 'commit_viewmodel.dart';

class CommitView extends StatelessWidget {
  const CommitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ViewModelBuilder<CommitViewModel>.nonReactive(
        viewModelBuilder: () => CommitViewModel(),
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
                              'Looks like you have changes to commit... (O.O)',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '\nCommit changes to cloud if you want your offline changes to be uploaded and saved to cloud database.\n\nThe \'Get data from cloud\' button pulls a fresh copy of files from the cloud database, in short this will delete your committed offline changes and restore last saved copy from cloud (This option is only recommended if you updated your account from another device and you want those changes to reflect in this device)',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CommitOfflineButton(),
                    CommitCloudButton(),
                    GetCloudButton(),
                  ],
                ),
              ),
            ));
  }
}

class CommitOfflineButton extends ViewModelWidget<CommitViewModel> {
  const CommitOfflineButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, CommitViewModel viewModel) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: GestureDetector(
        onTap: () {
          if (viewModel.checking1 ||
              viewModel.checking2 ||
              viewModel.checking3) {
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
          child: viewModel.checking1
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

class CommitCloudButton extends ViewModelWidget<CommitViewModel> {
  const CommitCloudButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, CommitViewModel viewModel) {
    return Positioned(
      bottom: 100,
      left: 20,
      right: 20,
      child: GestureDetector(
        onTap: () {
          if (viewModel.checking1 ||
              viewModel.checking2 ||
              viewModel.checking3) {
          } else {
            viewModel.commitToCloud();
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
                  'Commit changes to cloud',
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

class GetCloudButton extends ViewModelWidget<CommitViewModel> {
  const GetCloudButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, CommitViewModel viewModel) {
    return Positioned(
      bottom: 180,
      left: 20,
      right: 20,
      child: GestureDetector(
        onTap: () {
          if (viewModel.checking1 ||
              viewModel.checking2 ||
              viewModel.checking3) {
          } else {
            viewModel.getFromCloud();
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
          child: viewModel.checking3
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Text(
                  'Get data from cloud',
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
