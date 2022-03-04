import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quicknotes/app/app.dart';
import 'package:quicknotes/app/locator.dart';
import 'package:quicknotes/services/misc_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import '../../../app/colors.dart';
import 'note_viewmodel.dart';

class NoteView extends StatelessWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double taskHeight = MediaQuery.of(context).padding.top;

    return ViewModelBuilder<NoteViewModel>.nonReactive(
        viewModelBuilder: () => NoteViewModel(),
        onDispose: (viewModel) => viewModel.disposeControllers(),
        builder: (context, model, child) => GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus!.unfocus();
                model.isPalletBoxOpen = false;
              },
              child: Scaffold(
                body: GestureDetector(
                  onTap: () {
                    model.isPalletBoxOpen = false;
                    model.node2.requestFocus();
                  },
                  child: TitleTextHolder(taskHeight: taskHeight),
                ),
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(70),
                    child: NoteViewAppBar()),
              ),
            ));
  }
}

class TitleTextHolder extends ViewModelWidget<NoteViewModel> {
  const TitleTextHolder({
    Key? key,
    required this.taskHeight,
  }) : super(key: key);

  final double taskHeight;

  @override
  Widget build(BuildContext context, NoteViewModel viewModel) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
            top: -3,
            child: Container(
              width: size.width,
              height: 6,
              color: viewModel.note.color,
            )),
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          height: size.height - 70 - taskHeight,
          width: size.width,
          color: viewModel.note.color,
          child: SingleChildScrollView(
            controller: viewModel.scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTitleField(),
                AppTextField(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NoteViewAppBar extends ViewModelWidget<NoteViewModel> {
  NoteViewAppBar({
    Key? key,
    //  required this.scrollController,
  }) : super(key: key);

  //ScrollController scrollController;

  @override
  Widget build(BuildContext context, NoteViewModel viewModel) {
    return AnimatedTheme(
      data: viewModel.scrollController.offset > 0.0
          ? ThemeData(
              appBarTheme: AppBarTheme(
                  backgroundColor: viewModel.note.color!.withOpacity(0.84),
                  elevation: 2))
          : ThemeData(
              appBarTheme: AppBarTheme(
                  backgroundColor: viewModel.note.color, elevation: 0)),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(top: 12, left: 4),
          child: GestureDetector(
            child: Material(
                type: MaterialType.transparency,
                child: Icon(Icons.arrow_back_ios)),
            onTap: () => viewModel.navigateBack(),
          ),
        ),
        flexibleSpace: Container(
          alignment: Alignment.bottomRight,
          width: 310,
          height: 70 + MediaQuery.of(context).padding.top,
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              AnimatedPositioned(
                  duration: Duration(milliseconds: 80),
                  bottom: 22,
                  right: viewModel.isPalletBoxOpen ? 53 : 73,
                  child: Text(
                    'Color',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  )),
              ColorPelletBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorPelletBox extends ViewModelWidget<NoteViewModel> {
  const ColorPelletBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, NoteViewModel viewModel) {
    return Container(
      alignment: Alignment.centerRight,
      height: 70,
      width: 310,
      color: Colors.transparent,
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.only(
          right: 15,
        ),
        height: 60,
        width: viewModel.isPalletBoxOpen ? 290 : 60,
        decoration: BoxDecoration(
            color: viewModel.isPalletBoxOpen
                ? viewModel.note.color
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30)),
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            Positioned(
                left: 5,
                top: 5,
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    margin: EdgeInsets.only(right: 15),
                    height: 50,
                    width: viewModel.isPalletBoxOpen ? 280 : 50,
                    decoration: BoxDecoration(
                        color: viewModel.isPalletBoxOpen
                            ? Colors.white.withOpacity(0.5)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30)))),
            Positioned(
              left: 0,
              top: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 7,
                    ),
                    ColorPellet(
                      color: AppColors.purple,
                      colorName: 'purple',
                    ),
                    ColorPellet(
                      color: AppColors.primaryDark,
                      colorName: 'default',
                    ),
                    ColorPellet(
                      color: AppColors.sea,
                      colorName: 'sea',
                    ),
                    ColorPellet(
                      color: AppColors.yellow,
                      colorName: 'yellow',
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              top: 0,
              right: 0,
              child: GestureDetector(
                  onTap: () => viewModel.togglePalletBox(),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    clipBehavior: Clip.antiAlias,
                    alignment: Alignment.center,
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.transparent, shape: BoxShape.circle),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      margin: EdgeInsets.zero,
                      alignment: Alignment.center,
                      width: viewModel.isPalletBoxOpen ? 60 : 25,
                      height: viewModel.isPalletBoxOpen ? 60 : 25,
                      decoration: BoxDecoration(
                        color: viewModel.note.color,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            shape: BoxShape.circle),
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: viewModel.note.color,
                            border: Border.all(width: 3, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class ColorPellet extends ViewModelWidget<NoteViewModel> {
  ColorPellet({
    Key? key,
    required this.colorName,
    required this.color,
  }) : super(key: key);

  String colorName;
  Color color;

  @override
  Widget build(BuildContext context, NoteViewModel viewModel) {
    return GestureDetector(
      onTap: () => viewModel.setColor(colorName),
      child: Container(
        alignment: Alignment.center,
        width: 50,
        height: 50,
        decoration:
            BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: viewModel.isPalletBoxOpen ? color : Colors.transparent,
              boxShadow: [
                BoxShadow(
                    blurRadius: 2,
                    color: Colors.black
                        .withOpacity(viewModel.isPalletBoxOpen ? 0.9 : 0.0))
              ]),
        ),
      ),
    );
  }
}

class AppTitleField extends HookViewModelWidget<NoteViewModel> {
  AppTitleField({
    Key? key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, NoteViewModel viewModel) {
    var _titleController = useTextEditingController();
    if (!viewModel.titleInitialized) {
      _titleController.text = viewModel.note.title!;
      viewModel.titleInitialized = true;
    }

    return Container(
        margin: EdgeInsets.only(top: 10),
        child: TextField(
          onTap: () {
            viewModel.isPalletBoxOpen = false;
            viewModel.node1.requestFocus();
          },
          focusNode: viewModel.node1,
          maxLength: 50,
          maxLines: null,
          textAlignVertical: TextAlignVertical.center,
          style: GoogleFonts.openSans(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600)),
          controller: _titleController,
          onChanged: viewModel.setTitle,
          decoration: const InputDecoration(
              hintText: 'Add Title',
              hintStyle: TextStyle(
                  color: Color.fromARGB(255, 230, 230, 230),
                  fontSize: 26,
                  fontWeight: FontWeight.w500),
              counterText: '',
              border: InputBorder.none,
              isCollapsed: true,
              contentPadding:
                  EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 1)),
        ));
  }
}

class AppTextField extends HookViewModelWidget<NoteViewModel> {
  AppTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, NoteViewModel viewModel) {
    var _textController = useTextEditingController();
    if (!viewModel.textInitialized) {
      _textController.text = viewModel.note.text!;
      viewModel.textInitialized = true;
    }

    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) => viewModel.notifyListeners(),
    );

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: TextField(
          onTap: () {
            viewModel.isPalletBoxOpen = false;
            viewModel.node2.requestFocus();
          },
          focusNode: viewModel.node2,
          maxLength: 500,
          maxLines: null,
          textAlignVertical: TextAlignVertical.center,
          style: GoogleFonts.openSans(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400)),
          controller: _textController,
          onChanged: viewModel.setText,
          decoration: const InputDecoration(
              hintText: 'Add Text',
              hintStyle: TextStyle(
                  color: Color.fromARGB(255, 230, 230, 230),
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
              counterText: '',
              border: InputBorder.none,
              isCollapsed: true,
              contentPadding:
                  EdgeInsets.only(left: 17, right: 17, top: 5, bottom: 10))),
    );
  }
}
