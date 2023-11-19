import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:focused_menu/src/models/focused_menu_item.dart';
import 'package:focused_menu/src/widgets/toolbar_actions.dart';

class FocusedMenuDetails extends StatelessWidget {
  final List<FocusedMenuItem> menuItems;
  final BoxDecoration? menuBoxDecoration;
  final Offset childOffset;
  final double itemExtent;
  final Size childSize;
  final Widget child;
  final bool animateMenu;
  final double blurSize;
  final double? menuWidth;
  final Color blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;

  /// Actions to be shown in the toolbar.
  final List<Widget>? toolbarActions;

  /// Enable scroll in menu.
  final bool enableMenuScroll;

  /// The duration of the animation of the menu items. Default is 400ms.
  final Duration showItemsDuration;

  /// The border radius of the menu items card. Default is 0.0.
  final BorderRadius itemsCardBorderRadius;

  /// The widget to be used as seperator between menu items.
  final Widget? itemSeperatorWidget;

  final EdgeInsets itemPadding;

  /// Delta Duration for each item animation. Default is 200ms.
  final int itemAnimationDuration;

  const FocusedMenuDetails({
    Key? key,
    required this.menuItems,
    required this.child,
    required this.childOffset,
    required this.childSize,
    required this.menuBoxDecoration,
    this.itemExtent = 50.0,
    required this.animateMenu,
    required this.blurSize,
    this.blurBackgroundColor = const Color.fromRGBO(0, 0, 0, 0.7),
    required this.menuWidth,
    required this.enableMenuScroll,
    this.bottomOffsetHeight,
    this.menuOffset,
    this.toolbarActions,
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final maxMenuHeight = size.height * 0.45;
    final listHeight = menuItems.length * (itemExtent);

    final maxMenuWidth = menuWidth ?? (size.width * 0.70);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    final leftOffset = (childOffset.dx + maxMenuWidth) < size.width
        ? childOffset.dx
        : (childOffset.dx - maxMenuWidth + childSize.width);
    final topOffset = (childOffset.dy + menuHeight + childSize.height) <
            size.height - bottomOffsetHeight!
        ? childOffset.dy + childSize.height + menuOffset!
        : childOffset.dy - menuHeight - menuOffset!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurSize,
                    sigmaY: blurSize,
                  ),
                  child: Container(
                    color: blurBackgroundColor,
                  ),
                )),
            Positioned(
              top: topOffset,
              left: leftOffset,
              child: TweenAnimationBuilder(
                duration: showItemsDuration,
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Transform.scale(
                    scale: value,
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                tween: Tween(begin: 0.0, end: 1.0),
                child: Container(
                  width: maxMenuWidth,
                  height: menuHeight,
                  decoration: menuBoxDecoration ??
                      BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            const BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                spreadRadius: 1)
                          ]),
                  child: ClipRRect(
                    borderRadius: itemsCardBorderRadius,
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          itemSeperatorWidget ?? SizedBox.shrink(),
                      itemCount: menuItems.length,
                      padding: EdgeInsets.zero,
                      physics: enableMenuScroll
                          ? BouncingScrollPhysics()
                          : NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        FocusedMenuItem item = menuItems[index];
                        Widget listItem = GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              item.onPressed();
                            },
                            child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(bottom: 1),
                                color: item.backgroundColor ?? Colors.white,
                                height: itemExtent,
                                child: Padding(
                                  padding: itemPadding,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      item.title,
                                      if (item.trailing != null) ...[
                                        item.trailing!
                                      ]
                                    ],
                                  ),
                                )));
                        if (animateMenu) {
                          return TweenAnimationBuilder(
                              builder: (context, dynamic value, child) {
                                return Transform(
                                  transform: Matrix4.rotationX(1.5708 * value),
                                  alignment: Alignment.bottomCenter,
                                  child: child,
                                );
                              },
                              tween: Tween(begin: 1.0, end: 0.0),
                              duration: Duration(
                                  milliseconds: index * itemAnimationDuration),
                              child: listItem);
                        } else {
                          return listItem;
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (toolbarActions != null)
              ToolbarActions(toolbarActions: toolbarActions!),
            Positioned(
                top: childOffset.dy,
                left: childOffset.dx,
                child: AbsorbPointer(
                    absorbing: true,
                    child: Container(
                        width: childSize.width,
                        height: childSize.height,
                        child: child))),
          ],
        ),
      ),
    );
  }
}
