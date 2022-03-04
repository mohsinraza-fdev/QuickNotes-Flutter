import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:stacked/stacked.dart';

import '../../../../app/colors.dart';
import '../../../../models/note_model.dart';
import '../home_viewmodel.dart';
import 'delete_button.dart';

class NotesListView extends ViewModelWidget<HomeViewModel> {
  const NotesListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    Size size = MediaQuery.of(context).size;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        viewModel.searchBarHandler(notification);
        return true;
      },
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(bottom: 20, top: 80),
          child: viewModel.noDataFound
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      ' Press \'+\' to add a note',
                      style: TextStyle(color: AppColors.text, fontSize: 18),
                    ),
                  ),
                )
              : viewModel.filteredNotes.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          ' No match results found',
                          style: TextStyle(color: AppColors.text, fontSize: 18),
                        ),
                      ),
                    )
                  : ImplicitlyAnimatedReorderableList(
                      shrinkWrap: true,
                      primary: false,
                      physics: BouncingScrollPhysics(),
                      items: viewModel.filteredNotes,
                      areItemsTheSame: (a, b) => a == b,
                      onReorderFinished: (item, oldIndex, newIndex, itemList) =>
                          viewModel.reorder(oldIndex, newIndex),
                      itemBuilder: (context, itemAnimation, Note item, index) =>
                          Reorderable(
                        key: ValueKey(index),
                        builder: (context, dragAnimation, inDrag) {
                          final t = dragAnimation.value;
                          final elevation = lerpDouble(0, 8, t)!;
                          final color = Color.lerp(
                              Colors.white, Colors.white.withOpacity(0.8), t);

                          return SizeFadeTransition(
                            animation: itemAnimation,
                            sizeFraction: 0.7,
                            curve: Curves.easeInOutExpo,
                            child: Material(
                              color: color,
                              elevation: elevation,
                              type: MaterialType.transparency,
                              child: Handle(
                                delay: Duration(milliseconds: 200),
                                child: Container(
                                  width: size.width,
                                  height: 164,
                                  color: Colors.transparent,
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: inDrag
                                          ? [
                                              BoxShadow(
                                                blurRadius: 2,
                                                spreadRadius: 1,
                                                color: Colors.black
                                                    .withOpacity(0.4),
                                              ),
                                            ]
                                          : [
                                              BoxShadow(
                                                blurRadius: 2,
                                                spreadRadius: 1,
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: item.color!.withOpacity(0.84),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: GestureDetector(
                                        onTap: () {
                                          viewModel.navigateTo(item);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 14),
                                          decoration: BoxDecoration(
                                              color: inDrag
                                                  ? Colors.white
                                                      .withOpacity(0.2)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          width:
                                              size.width - (inDrag ? 38 : 40),
                                          height: inDrag ? 136 : 134,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 14,
                                                    left: 16,
                                                    right: 16,
                                                    bottom: 10),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth:
                                                                  size.width -
                                                                      110),
                                                      child: Text(
                                                        item.title! == ''
                                                            ? 'No Title'
                                                            : item.title!,
                                                        style: TextStyle(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.9),
                                                            fontSize: 28,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    DeleteButton(item: item),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 17),
                                                child: Text(
                                                  item.text! == ''
                                                      ? 'No Text'
                                                      : item.text!,
                                                  style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.9),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ),
    );
  }
}

/* class DeleteButton extends ViewModelWidget<HomeViewModel> {
  DeleteButton({Key? key, required this.index}) : super(key: key);

  int index;

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return GestureDetector(
      onTap: () {
        viewModel.deleteNote(index);
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
} */
