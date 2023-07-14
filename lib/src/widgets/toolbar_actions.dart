import 'package:flutter/material.dart';

class ToolbarActions extends StatelessWidget {
  final List<Widget> toolbarActions;
  const ToolbarActions({
    Key? key,
    required this.toolbarActions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Positioned(
      bottom: 0,
      child: Container(
        color: Colors.white,
        width: size.width,
        alignment: Alignment.topLeft,
        child: SafeArea(
          top: false,
          child: Row(
            children: toolbarActions,
          ),
        ),
      ),
    );
  }
}
