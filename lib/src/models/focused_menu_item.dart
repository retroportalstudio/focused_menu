import 'package:flutter/material.dart';

class FocusedMenuItem {
  Color? backgroundColor;
  Widget title;
  Widget? trailing;
  Function onPressed;
  bool closeOnTap;

  FocusedMenuItem({
    this.backgroundColor,
    required this.title,
    this.trailing,
    required this.onPressed,
    this.closeOnTap = true,
  });
}
