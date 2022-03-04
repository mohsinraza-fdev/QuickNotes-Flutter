import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:quicknotes/app/colors.dart';
import 'package:quicknotes/ui/views/home/home_viewmodel.dart';
import 'package:quicknotes/ui/views/loading_screen/loading_screen_view.dart';
import 'package:stacked/stacked.dart';
import 'components/custom_app_bar.dart';
import 'components/floating_add_note_button.dart';
import 'components/notes_list_view.dart';
import 'components/search_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double appBarHeight = 70;
    double taskHeight = MediaQuery.of(context).padding.top;

    return ViewModelBuilder<HomeViewModel>.nonReactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (viewModel) => viewModel.filter(''),
      builder: (context, model, child) => GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          body: Stack(
            children: [
              BodyContainer(appBarHeight: appBarHeight, taskHeight: taskHeight),
              SearchBar(size: size),
              Positioned(top: 0 - appBarHeight, child: LoadingScreen())
            ],
          ),
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: CustomAppBar(),
          ),
          floatingActionButton: const FloatingAddNoteButton(),
        ),
      ),
    );
  }
}

class BodyContainer extends ViewModelWidget<HomeViewModel> {
  const BodyContainer({
    Key? key,
    required this.appBarHeight,
    required this.taskHeight,
  }) : super(key: key);
  final double appBarHeight;
  final double taskHeight;

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.topCenter,
      height: size.height - appBarHeight - taskHeight,
      color: AppColors.primaryDark,
      child: NotesListView(),
    );
  }
}

/* class NotesListView extends ViewModelWidget<HomeViewModel> {
  const NotesListView({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        viewModel.searchBarHandler(notification);
        return true;
      },
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(bottom: 20, top: 60),
          child: viewModel.noDataFound
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      ' Press \'+\' to add a note',
                      style: TextStyle(
                          color: AppColors.text, fontSize: 18),
                    ),
                  ),
                )
              : viewModel.filteredNotes.isEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          ' No match results found',
                          style: TextStyle(
                              color: AppColors.text, fontSize: 18),
                        ),
                      ),
                    )
                  : ImplicitlyAnimatedReorderableList(
                      shrinkWrap: true,
                      primary: false,
                      physics: BouncingScrollPhysics(),
                      items: viewModel.filteredNotes,
                      areItemsTheSame: (a, b) => a == b,
                      onReorderFinished:
                          (item, oldIndex, newIndex, itemList) =>
                              viewModel.reorder(oldIndex, newIndex),
                      itemBuilder: (context, itemAnimation,
                              Note item, index) =>
                          Reorderable(
                        key: ValueKey(index),
                        builder: (context, dragAnimation, inDrag) {
                          final t = dragAnimation.value;
                          final elevation = lerpDouble(0, 8, t)!;
                          final color = Color.lerp(Colors.white,
                              Colors.white.withOpacity(0.8), t);

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
                                  height: 150,
                                  color: Colors.transparent,
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: item.color,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      boxShadow: inDrag
                                          ? [
                                              BoxShadow(
                                                blurRadius: 3,
                                                spreadRadius: 1,
                                                color: Colors.black
                                                    .withOpacity(
                                                        0.2),
                                              ),
                                            ]
                                          : [
                                              BoxShadow(
                                                blurRadius: 2,
                                                spreadRadius: 1,
                                                color: Colors.black
                                                    .withOpacity(
                                                        0.2),
                                                offset:
                                                    Offset(0, 1),
                                              ),
                                            ],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: inDrag
                                              ? Colors.white
                                                  .withOpacity(0.2)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(
                                                  10)),
                                      width: size.width -
                                          (inDrag ? 38 : 40),
                                      height: inDrag ? 122 : 120,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets
                                                        .only(
                                                    top: 14,
                                                    left: 17,
                                                    right: 17,
                                                    bottom: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                  item.title!,
                                                  style: TextStyle(
                                                      color: Colors
                                                          .white
                                                          .withOpacity(
                                                              0.9),
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight
                                                              .w500),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                  onTap: () {
                                                    viewModel
                                                        .deleteNote(
                                                            index);
                                                  },
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(
                                                              5),
                                                      alignment:
                                                          Alignment
                                                              .center,
                                                      width: 32,
                                                      height: 32,
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .black
                                                              .withOpacity(
                                                                  0.1),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  5)),
                                                      child:
                                                          SvgPicture
                                                              .asset(
                                                        'images/delete_icon.svg',
                                                        color: Color
                                                            .fromARGB(
                                                                255,
                                                                250,
                                                                77,
                                                                77),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets
                                                        .symmetric(
                                                    horizontal: 17),
                                            child: Text(
                                              item.text!,
                                              style: TextStyle(
                                                  color: Colors
                                                      .white
                                                      .withOpacity(
                                                          0.9),
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight
                                                          .w400),
                                              maxLines: 3,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                            ),
                                          )
                                        ],
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
} */

/* class FloatingAddNoteButton extends ViewModelWidget<HomeViewModel> {
  const FloatingAddNoteButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: FloatingActionButton.large(
        onPressed: () {
          viewModel.addNote();
        },
        child: Icon(
          Icons.add,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }
} */

/* class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 4, top: 15),
        child: Text(
          'My Notes',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
      ),
      actions: [LogoutButton()],
    );
  }
} */

/* class SearchBar extends HookViewModelWidget<HomeViewModel> {
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

    return Positioned(
      child: Visibility(
        visible: !(viewModel.percentage == 0.0),
        child: Container(
          constraints: BoxConstraints(minHeight: 20, minWidth: 150),
          alignment: Alignment.bottomCenter,
          width: size.width,
          height: 42 * viewModel.percentage,
          color: Colors.transparent,
          child: AnimatedContainer(
            constraints: BoxConstraints(minHeight: 20, minWidth: 150),
            alignment: Alignment.center,
            duration: Duration(milliseconds: 10),
            width: (size.width - 40) * viewModel.percentage,
            height: 30 * viewModel.percentage,
            decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(viewModel.percentage),
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
                          .withOpacity(0.5 * viewModel.percentage)),
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
} */

/* class LogoutButton extends ViewModelWidget<HomeViewModel> {
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
        viewModel.isLogoutButtonSelected = false;
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
            color: viewModel.isLogoutButtonselected
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
 */