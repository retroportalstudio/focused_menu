import 'package:flutter/material.dart';

class ToolbarButtonItem {
  Icon buttonIcon;
  Color? buttonIconColor;
  VoidCallback onPressed;

  ToolbarButtonItem({required this.buttonIcon, this.buttonIconColor, required this.onPressed});
}
