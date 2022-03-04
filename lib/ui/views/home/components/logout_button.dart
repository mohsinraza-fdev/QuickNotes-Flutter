import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../../app/colors.dart';
import '../home_viewmodel.dart';

class LogoutButton extends ViewModelWidget<HomeViewModel> {
  const LogoutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return GestureDetector(
      onTapDown: (details) {
        viewModel.isLogoutButtonSelected = true;
      },
      onTapUp: (details) {
        FocusManager.instance.primaryFocus!.unfocus();
        viewModel.isLogoutButtonSelected = false;
        if ((viewModel.showLoading == false) && viewModel.saveDataOnline) {
          viewModel.logout();
        }
      },
      onTapCancel: () {
        viewModel.isLogoutButtonSelected = false;
      },
      child: Container(
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 15),
        margin: EdgeInsets.only(
          right: 18,
          top: 15,
          /* bottom: appBarHeight * 0.05  */
        ),
        decoration: BoxDecoration(
            color:
                !((viewModel.showLoading == false) && viewModel.saveDataOnline)
                    ? Colors.grey
                    : viewModel.isLogoutButtonselected
                        ? AppColors.primaryDark
                        : AppColors.primaryDark.withOpacity(0.8),
            borderRadius: BorderRadius.circular(25)),
        child: Row(
          children: [
            Text(
              ' Logout',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.logout_rounded,
              color: Colors.white.withOpacity(0.8),
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}
