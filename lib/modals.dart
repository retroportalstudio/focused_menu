import 'package:flutter/material.dart';

class FocusedMenuItem {
  Color? backgroundColor;
  Widget title;
  Icon? trailingIcon;
  Function onPressed;

  FocusedMenuItem({this.backgroundColor, required this.title, this.trailingIcon, required this.onPressed});
}

class ToolbarButtonItem {
  String buttonTitle;
  Color? buttonTextColor;
  VoidCallback onPressed;

  ToolbarButtonItem({required this.buttonTitle, this.buttonTextColor, required this.onPressed});
}
