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

  /// The height of each menu item. Default is 50.0.
  final double menuItemExtent;

  /// The width of the menu. If not specified, it will be 70% of the screen width.
  final double? menuWidth;
  final List<FocusedMenuItem> menuItems;

  /// Whether the menu items should animate in default to true.
  final bool animateMenuItems;

  /// The decoration to paint behind the menu items.
  final BoxDecoration? menuBoxDecoration;

  /// The callback that is called when one of the menu items is pressed.
  final Function? onPressed;

  /// The duration of the animation of the menu items. Default is 100ms.
  final Duration duration;

  /// The blur size of the background. Default is 4.0.
  final double blurSize;

  /// The color to use for the unfocused area.
  final Color blurBackgroundColor;

  /// The height of the bottom offset used as bottom safe area. Default is 0.
  final double bottomOffsetHeight;

  /// The height of the menu offset used as top safe area. Default is 0.
  final double menuOffset;

  /// Actions to be shown in the toolbar.
  final List<Widget>? toolbarActions;

  /// Enable scroll in menu. Default is true.
  final bool enableMenuScroll;

  /// Open with tap insted of long press.
  final bool openWithTap;

  /// Controller to open and close the menu.
  final FocusedMenuHolderController? controller;
  final VoidCallback? onOpened;
  final VoidCallback? onClosed;

  /// The duration of the animation of the menu items. Default is 400ms.
  final Duration showItemsDuration;

  /// The border radius of the menu items card. Default is 0.0.
  final BorderRadius itemsCardBorderRadius;

  /// The widget to be used as seperator between menu items.
  final Widget? itemSeperatorWidget;

  /// The padding of the menu items.
  final EdgeInsets itemPadding;

  /// Delta Duration for each item animation. Default is 200ms.
  final int itemAnimationDuration;

  const FocusedMenuHolder({
    Key? key,
    required this.child,
    required this.menuItems,
    this.onPressed,
    this.duration = const Duration(milliseconds: 100),
    this.menuBoxDecoration,
    this.menuItemExtent = 50.0,
    this.animateMenuItems = true,
    this.blurSize = 4.0,
    this.blurBackgroundColor = const Color.fromRGBO(0, 0, 0, 0.7),
    this.menuWidth,
    this.bottomOffsetHeight = 0,
    this.menuOffset = 0,
    this.toolbarActions,
    this.enableMenuScroll = true,
    this.openWithTap = false,
    this.controller,
    this.onOpened,
    this.onClosed,
    this.showItemsDuration = const Duration(milliseconds: 400),
    this.itemsCardBorderRadius = const BorderRadius.all(Radius.zero),
    this.itemSeperatorWidget,
    this.itemPadding = const EdgeInsets.symmetric(
      vertical: 8.0,
      horizontal: 14,
    ),
    this.itemAnimationDuration = 200,
  }) : super(key: key);

  @override
  _FocusedMenuHolderState createState() => _FocusedMenuHolderState(controller);
}

class _FocusedMenuHolderState extends State<FocusedMenuHolder> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset(0, 0);
  late Size childSize;

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

    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: widget.duration,
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
              animateMenu: widget.animateMenuItems,
              bottomOffsetHeight: widget.bottomOffsetHeight,
              menuOffset: widget.menuOffset,
              toolbarActions: widget.toolbarActions,
              enableMenuScroll: widget.enableMenuScroll,
              showItemsDuration: widget.showItemsDuration,
              itemsCardBorderRadius: widget.itemsCardBorderRadius,
              itemSeperatorWidget: widget.itemSeperatorWidget,
              itemPadding: widget.itemPadding,
              itemAnimationDuration: widget.itemAnimationDuration,
            ),
          );
        },
        fullscreenDialog: true,
        opaque: false,
      ),
    ).whenComplete(() => widget.onClosed?.call());
  }
}
