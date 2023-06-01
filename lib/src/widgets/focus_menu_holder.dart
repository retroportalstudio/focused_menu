import 'package:flutter/material.dart';
import 'package:focused_menu/src/models/focused_menu_item.dart';
import 'package:focused_menu/src/widgets/focused_menu_datails.dart';

class FocusedMenuHolderController {
  late _FocusedMenuHolderState _widgetState;
  bool _isOpened = false;

  void _addState(_FocusedMenuHolderState widgetState) {
    this._widgetState = widgetState;
  }

  void open() {
    _widgetState.openMenu(_widgetState.context);
    _isOpened = true;
  }

  void close() {
    if (_isOpened) {
      Navigator.pop(_widgetState.context);
      _isOpened = false;
    }
  }
}

class FocusedMenuHolder extends StatefulWidget {
  final Widget child;
  final double? menuItemExtent;
  final double? menuWidth;
  final List<FocusedMenuItem> menuItems;
  final bool? animateMenuItems;
  final BoxDecoration? menuBoxDecoration;
  final Function? onPressed;
  final Duration? duration;
  final double? blurSize;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;

  /// If true, the menu will be opened in the root navigator. Use it only if you are using multiple navigators.
  /// Default is false.
  final bool rootNavitator;

  /// Open with tap insted of long press.
  final bool openWithTap;
  final FocusedMenuHolderController? controller;
  final VoidCallback? onOpened;
  final VoidCallback? onClosed;
  final Alignment? align;

  const FocusedMenuHolder({
    Key? key,
    required this.child,
    required this.menuItems,
    this.onPressed,
    this.duration,
    this.menuBoxDecoration,
    this.menuItemExtent,
    this.animateMenuItems,
    this.blurSize,
    this.blurBackgroundColor,
    this.menuWidth,
    this.bottomOffsetHeight,
    this.menuOffset,
    this.rootNavitator = false,
    this.openWithTap = false,
    this.align,
    this.controller,
    this.onOpened,
    this.onClosed,
  }) : super(key: key);

  @override
  _FocusedMenuHolderState createState() => _FocusedMenuHolderState(controller);
}

class _FocusedMenuHolderState extends State<FocusedMenuHolder> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset(0, 0);
  Size? childSize;

  _FocusedMenuHolderState(FocusedMenuHolderController? _controller) {
    if (_controller != null) {
      _controller._addState(this);
    }
  }

  void _getOffset() {
    RenderBox renderBox =
        containerKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      this.childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: containerKey,
        onTap: () async {
          widget.onPressed?.call();
          if (widget.openWithTap) {
            await openMenu(context);
          }
        },
        onLongPress: () async {
          if (!widget.openWithTap) {
            await openMenu(context);
          }
        },
        child: widget.child);
  }

  Future openMenu(BuildContext context) async {
    _getOffset();
    widget.onOpened?.call();

    await Navigator.of(context, rootNavigator: widget.rootNavitator)
        .push(
          PageRouteBuilder(
            transitionDuration: widget.duration ?? Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              animation = Tween(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: FocusedMenuDetails(
                  itemExtent: widget.menuItemExtent,
                  menuBoxDecoration: widget.menuBoxDecoration,
                  child: widget.child,
                  childOffset: childOffset,
                  childSize: childSize,
                  menuItems: widget.menuItems,
                  blurSize: widget.blurSize,
                  menuWidth: widget.menuWidth,
                  blurBackgroundColor: widget.blurBackgroundColor,
                  animateMenu: widget.animateMenuItems ?? true,
                  bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
                  menuOffset: widget.menuOffset ?? 0,
                  align: widget.align,
                ),
              );
            },
            fullscreenDialog: true,
            opaque: false,
          ),
        )
        .whenComplete(() => widget.onClosed?.call());
  }
}
