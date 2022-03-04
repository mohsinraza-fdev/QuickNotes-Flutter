import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'loading_screen_viewmodel.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<LoadingScreenViewModel>.reactive(
        viewModelBuilder: () => LoadingScreenViewModel(),
        builder: (context, model, child) => model.showLoading
            ? Container(
                color: Colors.black.withOpacity(0.9),
                width: size.width,
                height: size.height,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpinKitFoldingCube(
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Material(
                      type: MaterialType.transparency,
                      child: Text(
                        model.showMessage,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  ],
                ),
              )
            : Visibility(visible: false, child: Container()));
  }
}
