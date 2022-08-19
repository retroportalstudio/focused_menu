import 'package:flutter/material.dart';

class FocusedMenuItem {
  bool isSpace;
  Color? backgroundColor;
  Widget? title;
  Widget? trailingIcon;
  Function? onPressed;

  FocusedMenuItem({
    this.isSpace = false,
    this.backgroundColor,
    this.title,
    this.trailingIcon,
    this.onPressed,
  });
}
