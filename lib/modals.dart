import 'package:flutter/material.dart';

class FocusedMenuItem {
  Color? backgroundColor;
  Widget title;
  Icon? trailingIcon;
  Function onPressed;

  FocusedMenuItem({this.backgroundColor, required this.title, this.trailingIcon, required this.onPressed});
}

class ToolbarButtonItem {
  Icon buttonIcon;
  Color? buttonIconColor;
  VoidCallback onPressed;

  ToolbarButtonItem({required this.buttonIcon, this.buttonIconColor, required this.onPressed});
}
