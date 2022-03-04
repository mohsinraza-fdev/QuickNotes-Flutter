import 'package:flutter/material.dart';
import 'package:quicknotes/ui/views/authentication/authentication_view.dart';
import 'package:quicknotes/ui/views/loading_screen/loading_screen_view.dart';
import 'package:stacked/stacked.dart';

import '../home/home_view.dart';
import 'wrapper_viewmodel.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WrapperViewModel>.reactive(
        viewModelBuilder: () => WrapperViewModel(),
        onModelReady: (viewModel) => viewModel.verifyUserNull(),
        builder: (context, model, child) => !model.userNullVerified
            ? LoadingScreen()
            : model.user == null
                ? AuthenticationView()
                : HomeView());
  }
}
