import 'package:flutter/material.dart';

class FocusedMenuItem extends StatefulWidget {
  const FocusedMenuItem({
    Key? key,
    this.backgroundColor,
    required this.title,
    this.trailingIcon,
    required this.onPressed,
    this.itemExtent,
    this.onItemEnter,
    this.onItemExit,
    this.onItemHover,
    this.onHoverColor,
  }) : super(key: key);

  final Color? backgroundColor;
  final Widget title;
  final Icon? trailingIcon;
  final Function onPressed;
  final Function? onItemHover;
  final Function? onItemEnter;
  final Function? onItemExit;
  final Color? onHoverColor;

  /// Height of List Item. Defaults to 50.
  final double? itemExtent;

  @override
  _FocusedMenuItemState createState() => _FocusedMenuItemState();
}

class _FocusedMenuItemState extends State<FocusedMenuItem> {
  late Color bgColor;

  @override
  void initState() {
    bgColor = widget.backgroundColor ?? Colors.white;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        (widget.onItemHover ?? () {})();
      },
      onEnter: (event) {
        (widget.onItemEnter ?? () {})();
        setState(() {
          bgColor = widget.onHoverColor ?? bgColor;
        });
      },
      onExit: (event) {
        (widget.onItemExit ?? () {})();
        setState(() {
          bgColor = widget.backgroundColor ?? bgColor;
        });
      },
      child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 1),
          color: bgColor,
          height: widget.itemExtent ?? 50.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                widget.title,
                if (widget.trailingIcon != null) ...[widget.trailingIcon!]
              ],
            ),
          )),
    );
  }
}
