import 'package:flutter/material.dart';
import 'package:quicknotes/app/colors.dart';

class Note {
  String? text;
  String? colorName;
  Color? color;
  String? title;

  Note({String? title, String? text, String? colorName}) {
    this.text = text ?? '';
    this.title = title ?? '';
    this.colorName = colorName ?? "default";
    setColor(this.colorName);
  }

  void setColor(value) {
    switch (value) {
      case "default":
        {
          color = AppColors.primaryDark;
        }
        break;
      case "yellow":
        {
          color = AppColors.yellow;
        }
        break;
      case "purple":
        {
          color = AppColors.purple;
        }
        break;
      case "sea":
        {
          color = AppColors.sea;
        }
        break;
    }
  }
}
