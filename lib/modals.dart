import 'package:flutter/material.dart';

class FocusedMenuItem {
  Color backgroundColor;
  Widget title;
  Widget trailingIcon;
  Function onPressed;

  FocusedMenuItem(
      {this.backgroundColor,
      @required this.title,
      this.trailingIcon,
      @required this.onPressed});
}
