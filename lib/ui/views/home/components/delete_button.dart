import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

import '../../../../models/note_model.dart';
import '../home_viewmodel.dart';

class DeleteButton extends ViewModelWidget<HomeViewModel> {
  DeleteButton({Key? key, required this.item}) : super(key: key);

  Note item;

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return GestureDetector(
      onTap: () {
        viewModel.deleteNote(item);
      },
      child: Container(
          padding: EdgeInsets.all(5),
          alignment: Alignment.center,
          width: 32,
          height: 32,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 230, 230, 230),
              borderRadius: BorderRadius.circular(5)),
          child: SvgPicture.asset(
            'images/delete_icon.svg',
            color: Color.fromARGB(255, 184, 0, 0),
          )),
    );
  }
}
