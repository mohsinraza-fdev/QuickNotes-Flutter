import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import '../../../../app/colors.dart';
import '../home_viewmodel.dart';

class SearchBar extends HookViewModelWidget<HomeViewModel> {
  const SearchBar({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;
  final _textController = useTextEditingController;

  @override
  Widget buildViewModelWidget(BuildContext context, HomeViewModel viewModel) {
    final _textController = useTextEditingController();
    if (viewModel.clearController) {
      _textController.clear();
      viewModel.clearController = false;
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) => viewModel.setUp());

    return Positioned(
      child: Visibility(
        visible: !(viewModel.percentage == 0.0),
        child: Container(
          constraints: BoxConstraints(minHeight: 25, minWidth: 150),
          alignment: Alignment.bottomCenter,
          width: size.width,
          height: 56 * viewModel.percentage,
          color: Colors.transparent,
          child: AnimatedContainer(
            constraints: BoxConstraints(minHeight: 20, minWidth: 150),
            alignment: Alignment.center,
            duration: Duration(milliseconds: 10),
            width: (size.width - 40) * viewModel.percentage,
            height: 40 * viewModel.percentage,
            decoration: BoxDecoration(
                color: AppColors.primaryLight
                    .withOpacity(0.30 * viewModel.percentage),
                borderRadius: BorderRadius.circular(45)),
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(color: AppColors.text),
              maxLines: 1,
              controller: _textController,
              onChanged: viewModel.filter,
              decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.search,
                    color: AppColors.text.withOpacity(viewModel.percentage),
                  ),
                  suffixIconColor: AppColors.text,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                      color: AppColors.text
                          .withOpacity(0.7 * viewModel.percentage)),
                  isCollapsed: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14)),
            ),
          ),
        ),
      ),
      top: 10,
    );
  }
}
