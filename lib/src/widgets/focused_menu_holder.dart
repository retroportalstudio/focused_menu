import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:focused_menu/src/models/focused_menu_item.dart';
import 'package:focused_menu/src/widgets/focused_menu_datails.dart';

const _duration = Duration(milliseconds: 100);

/// {@macro focused_menu_holder}
///
/// This widget is used to controll the animation of the menu
/// when showing and hiding the [FocusedMenuDetails].
class FocusedMenuHolder extends StatefulWidget {
  /// The widget that will be used as the child.
  ///
  /// This is the widget that will be used as the anchor for the menu.
  final Widget child;

  /// {@macro focused_menu_holder.menuItems}
  final double? itemExtent;

  /// {@macro focused_menu_holder.menuWidth}
  final double? menuWidth;

  /// {@macro focused_menu_holder.menuItems}
  final List<FocusedMenuItem> menuItems;

  /// {@macro focused_menu_holder.animateMenuItems}
  final bool? animateMenuItems;

  /// {@macro focused_menu_holder.menuBoxDecoration}
  final BoxDecoration? menuBoxDecoration;

  /// Callback to be called when the child is pressed.
  final Function? onPressed;

  /// Duration of the animation.
  ///
  /// Defaults to 100 milliseconds.
  final Duration? duration;

  /// {@macro focused_menu_details.blurSize}
  final double? blurSize;

  /// {@macro focused_menu_details.blurBackgroundColor}
  final Color? blurBackgroundColor;

  /// {@macro focused_menu_details.bottomOffsetHeight}
  final double? bottomOffsetHeight;

  /// {@macro focused_menu_details.menuOffset}
  final double? menuOffset;

  /// {@macro focused_menu_details.toolbarActions}
  final List<Widget>? toolbarActions;

  /// {@macro focused_menu_details.enableMenuScroll}
  final bool enableMenuScroll;

  /// {@macro focused_menu_details.openWithTap}
  ///
  /// Trigger for opening the menu.
  ///
  /// Default to [OpenMode.onLongPress].
  final OpenMode openMode;

  /// Controller to extend the functionality of the menu.
  ///
  /// You can use this controller to open or close the menu programatically
  final FocusedMenuHolderController? controller;

  /// {@macro focused_menu_details.onOpened}
  ///
  /// Callback to be called when the menu is opened.
  final VoidCallback? onOpened;

  /// {@macro focused_menu_details.onClosed}
  ///
  /// Callback to be called when the menu is closed.
  final VoidCallback? onClosed;

  const FocusedMenuHolder({
    Key? key,
    required this.child,
    required this.menuItems,
    this.onPressed,
    this.duration,
    this.menuBoxDecoration,
    this.itemExtent,
    this.animateMenuItems,
    this.blurSize,
    this.blurBackgroundColor,
    this.menuWidth,
    this.bottomOffsetHeight,
    this.menuOffset,
    this.toolbarActions,
    this.enableMenuScroll = true,
    this.openMode = OpenMode.onLongPress,
    this.controller,
    this.onOpened,
    this.onClosed,
  }) : super(key: key);

  @override
  State createState() => _FocusedMenuHolderState();
}

class _FocusedMenuHolderState extends State<FocusedMenuHolder> {
  final GlobalKey _containerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      widget.controller!._addState(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _containerKey,
      onTap: widget.openMode == OpenMode.onTap ? _openMenu : null,
      onLongPress: widget.openMode == OpenMode.onLongPress ? _openMenu : null,
      child: widget.child,
    );
  }

  RenderBox _getRenderBox() {
    final cContext = _containerKey.currentContext;
    RenderBox renderBox = cContext!.findRenderObject() as RenderBox;

    return renderBox;
  }

  Future<void> _openMenu() async {
    RenderBox renderBox = _getRenderBox();
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    final menuOffset = Offset(offset.dx, offset.dy);
    final childSize = size;

    widget.onPressed?.call();
    widget.onOpened?.call();

    try {
      await _show(menuOffset, childSize);
    } catch (e, stack) {
      log(e.toString(), stackTrace: stack);
    }

    widget.onClosed?.call();
  }

  Future<dynamic> _show(Offset offset, Size? size) async {
    return Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: widget.duration ?? _duration,
        fullscreenDialog: true,
        opaque: false,
        pageBuilder: (_, animation, __) {
          animation = Tween(begin: 0.0, end: 1.0).animate(animation);
          return FadeTransition(
            opacity: animation,
            child: FocusedMenuDetails(
              itemExtent: widget.itemExtent,
              menuBoxDecoration: widget.menuBoxDecoration,
              childOffset: offset,
              childSize: size,
              menuItems: widget.menuItems,
              blurSize: widget.blurSize,
              menuWidth: widget.menuWidth,
              blurBackgroundColor: widget.blurBackgroundColor,
              animateMenuItems: widget.animateMenuItems,
              bottomOffsetHeight: widget.bottomOffsetHeight,
              menuOffset: widget.menuOffset,
              toolbarActions: widget.toolbarActions,
              enableMenuScroll: widget.enableMenuScroll,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

/// Controller to extend the functionality of the menu.
///
/// You can use this controller to open the menu programatically
class FocusedMenuHolderController {
  late _FocusedMenuHolderState _widgetState;

  void _addState(_FocusedMenuHolderState widgetState) {
    _widgetState = widgetState;
  }

  void open() {
    _widgetState._openMenu();
  }
}

enum OpenMode { onTap, onLongPress }
