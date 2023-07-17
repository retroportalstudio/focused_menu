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
  final bool? animateMenuItems;

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
    this.childSize,
    this.itemExtent,
    this.blurSize,
    this.blurBackgroundColor,
    this.menuWidth,
    this.menuBoxDecoration,
    this.bottomOffsetHeight,
    this.menuOffset,
    this.toolbarActions,
    this.animateMenuItems,
    this.enableMenuScroll = true,
  }) : super(key: key);

  double _getLeftOffset(Size screenSize) {
    // Calculate the maximum width of the menu.
    // This is either provided or defaults to 70% of the screen width.
    final maxMenuWidth = menuWidth ?? (screenSize.width * 0.70);

    // Calculate the potential new left offset by adding maxMenuWidth
    // to child's horizontal distance.
    final potentialLeftOffset = childOffset.dx + maxMenuWidth;

    // Check if the potential left offset fits within the screen width.
    bool doesOffsetFitWithinScreenWidth =
        potentialLeftOffset < screenSize.width;

    // Calculate the overflow offset when the potential left offset doesn't
    // fit within the screen width.
    final overflowOffset = childOffset.dx - maxMenuWidth + childSize!.width;

    // The final left offset is either the child's horizontal distance or
    // the overflow offset,  depending on whether the potential left offset
    // fits the screen width.
    final leftOffset =
        doesOffsetFitWithinScreenWidth ? childOffset.dx : overflowOffset;

    return leftOffset;
  }

  double _getTopOffset(Size screenSize, double menuHeight) {
    // Calculate the potential top offset by adding menuHeight and child's
    // height to child's vertical distance.
    final potentialTopOffset = childOffset.dy + menuHeight + childSize!.height;

    // Calculate the threshold for the top offset, which is the screen height
    // minus the bottom offset height.
    final topOffsetThreshold = screenSize.height - (bottomOffsetHeight ?? 0);

    // Check if the potential top offset is less than the threshold.
    bool doesOffsetFitWithinScreenHeight =
        potentialTopOffset < topOffsetThreshold;

    // Calculate the overflow offset when the potential top offset doesn't fit
    // within the screen height.
    final overflowOffset = childOffset.dy - menuHeight - (menuOffset ?? 0);

    // The final top offset is either the new offset or the overflow offset,
    // depending on whether the potential top offset fits within the screen height.
    final topOffset = doesOffsetFitWithinScreenHeight
        ? childOffset.dy + childSize!.height + (menuOffset ?? 0)
        : overflowOffset;

    return topOffset;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final maxMenuHeight = size.height * 0.45;
    final listHeight = menuItems.length * (itemExtent ?? 50.0);

    final maxMenuWidth = menuWidth ?? (size.width * 0.70);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;

    final leftOffset = _getLeftOffset(size);
    final topOffset = _getTopOffset(size, menuHeight);

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
            animateMenuItems: animateMenuItems,
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
