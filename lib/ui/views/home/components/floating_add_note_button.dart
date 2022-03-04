import 'package:flutter/material.dart';
import 'package:quicknotes/app/colors.dart';
import 'package:stacked/stacked.dart';

import '../home_viewmodel.dart';

class FloatingAddNoteButton extends ViewModelWidget<HomeViewModel> {
  const FloatingAddNoteButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7, right: 5),
      child: FloatingActionButton.large(
        backgroundColor: viewModel.showLoading ? Colors.grey : AppColors.green,
        onPressed: () {
          if (viewModel.showLoading == false) {
            viewModel.addNote();
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }
}
