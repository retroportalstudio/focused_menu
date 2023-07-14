import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:focused_menu/src/models/focused_menu_item.dart';
import 'package:focused_menu/src/widgets/focused_menu_widget.dart';
import 'package:focused_menu/src/widgets/toolbar_actions.dart';

/// {@macro focused_menu_holder}
///
/// A widget that holds the [child] and the [FocusedMenuDetails].
class FocusedMenuDetails extends StatelessWidget {
  /// {@macro focused_menu_holder.child}
  final Widget child;

  /// {@macro focused_menu_holder.menuItems}
  ///
  /// List of [FocusedMenuItem] to be shown in the menu.
  final List<FocusedMenuItem> menuItems;

  /// {@macro focused_menu_holder.menuBoxDecoration}
  ///
  /// Decoration of the menu.
  final BoxDecoration? menuBoxDecoration;

  /// {@macro focused_menu_holder.childOffset}
  final Offset childOffset;

  /// {@macro focused_menu_holder.itemExtent}
  ///
  /// Heigh of each menu item.
  ///
  /// Defaults to 50.0.
  final double? itemExtent;

  /// {@macro focused_menu_holder.chilsSize}
  ///
  /// Size of the child widget.
  final Size? childSize;

  /// {@macro focused_menu_holder.animateMenuItems}
  ///
  /// Whether the menu items should be animated or not.
  final bool animateMenu;

  /// {@macro focused_menu_holder.menuWidth}
  ///
  /// Width of the menu.
  ///
  /// Defaults to size.width * 0.70
  final double? menuWidth;

  /// {@macro focused_menu_details.blurSize}
  ///
  /// Value of the blur applied to the background.
  /// Defaults to 4.0.
  final double? blurSize;

  /// {@macro focused_menu_details.blurBackgroundColor}
  ///
  /// Color of the background.
  /// Defaults to black.
  ///
  /// Note: The opacity of the color is set to 0.7.
  final Color? blurBackgroundColor;

  /// {@macro focused_menu_details.bottomOffsetHeight}
  ///
  /// Height of the bottom offset.
  /// This is useful when you don't want to show the
  /// menu so close to the bottom of the screen.
  ///
  /// Defaults to 0.0.
  final double? bottomOffsetHeight;

  /// {@macro focused_menu_details.menuOffset}
  ///
  /// Offset of the menu.
  /// This is useful when you want to show the menu
  /// with a bigger distance from the child.
  ///
  /// Defaults to 0.0.
  final double? menuOffset;

  /// {@macro focused_menu_details.toolbarActions}
  ///
  /// Actions to be shown in the toolbar.
  final List<Widget>? toolbarActions;

  /// {@macro focused_menu_details.enableMenuScroll}
  ///
  /// Enable scroll in the menu.
  ///
  /// Default to true.
  final bool enableMenuScroll;

  const FocusedMenuDetails({
    Key? key,
    required this.menuItems,
    required this.child,
    required this.childOffset,
    required this.childSize,
    required this.menuBoxDecoration,
    required this.itemExtent,
    required this.animateMenu,
    required this.blurSize,
    required this.blurBackgroundColor,
    required this.menuWidth,
    required this.enableMenuScroll,
    this.bottomOffsetHeight,
    this.menuOffset,
    this.toolbarActions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final maxMenuHeight = size.height * 0.45;
    final listHeight = menuItems.length * (itemExtent ?? 50.0);

    final maxMenuWidth = menuWidth ?? (size.width * 0.70);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    final leftOffset = (childOffset.dx + maxMenuWidth) < size.width
        ? childOffset.dx
        : (childOffset.dx - maxMenuWidth + childSize!.width);
    final topOffset = (childOffset.dy + menuHeight + childSize!.height) <
            size.height - bottomOffsetHeight!
        ? childOffset.dy + childSize!.height + menuOffset!
        : childOffset.dy - menuHeight - menuOffset!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _BackgroundBlur(
            blurSize: blurSize,
            blurBackgroundColor: blurBackgroundColor,
          ),
          FocusedMenuWidget(
            topOffset: topOffset,
            leftOffset: leftOffset,
            maxMenuWidth: maxMenuWidth,
            menuHeight: menuHeight,
            menuBoxDecoration: menuBoxDecoration,
            menuItems: menuItems,
            enableMenuScroll: enableMenuScroll,
            itemExtent: itemExtent,
            animateMenu: animateMenu,
          ),
          if (toolbarActions != null)
            ToolbarActions(toolbarActions: toolbarActions!),
          _FocusedChild(
            childOffset: childOffset,
            childSize: childSize,
            child: child,
          ),
        ],
      ),
    );
  }
}

class _FocusedChild extends StatelessWidget {
  const _FocusedChild({
    Key? key,
    required this.childOffset,
    required this.childSize,
    required this.child,
  }) : super(key: key);

  final Offset childOffset;
  final Size? childSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: childOffset.dy,
      left: childOffset.dx,
      child: AbsorbPointer(
        absorbing: true,
        child: SizedBox(
          width: childSize!.width,
          height: childSize!.height,
          child: child,
        ),
      ),
    );
  }
}

/// Widget that applies a blur effect to the background.
class _BackgroundBlur extends StatelessWidget {
  const _BackgroundBlur({
    Key? key,
    required this.blurSize,
    required this.blurBackgroundColor,
  }) : super(key: key);

  /// {@macro focused_menu_details.blurSize}
  final double? blurSize;

  /// {@macro focused_menu_details.blurBackgroundColor}
  final Color? blurBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurSize ?? 4,
          sigmaY: blurSize ?? 4,
        ),
        child: Container(
          color: (blurBackgroundColor ?? Colors.black).withOpacity(0.7),
        ),
      ),
    );
  }
}
