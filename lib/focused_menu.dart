library focused_menu;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';

class FocusedMenuHolder extends StatefulWidget {
  final Widget child;
  final double menuItemExtent;
  final double menuWidth;
  final List<FocusedMenuItem> menuItems;
  final bool animateMenuItems;
  final BoxDecoration menuBoxDecoration;
  final Function onPressed;
  final Duration duration;
  final double blurSize;
  final Color blurBackgroundColor;
  final double bottomOffsetHeight;
  final double menuOffset;
  final double customLeftOffset;
  final double customRightOffset;
  final Alignment menuItemsAlignment;
  final BorderRadius listViewBorderRadius;

  /// Open with tap insted of long press.
  final bool openWithTap;

  const FocusedMenuHolder(
      {Key key,
      @required this.child,
      @required this.onPressed,
      @required this.menuItems,
      this.duration,
      this.menuBoxDecoration,
      this.menuItemExtent,
      this.animateMenuItems,
      this.blurSize,
      this.blurBackgroundColor,
      this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset,
      this.customLeftOffset,
      this.customRightOffset,
      this.menuItemsAlignment,
      this.listViewBorderRadius,
      this.openWithTap = false})
      : super(key: key);

  @override
  _FocusedMenuHolderState createState() => _FocusedMenuHolderState();
}

class _FocusedMenuHolderState extends State<FocusedMenuHolder> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset(0, 0);
  Size childSize;

  getOffset() {
    RenderBox renderBox = containerKey.currentContext.findRenderObject();
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
          widget.onPressed();
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
    getOffset();
    double setmenuHeight = 0.0;
    widget.menuItems.forEach((element) {
      if (element != null) {
        setmenuHeight += widget.menuItemExtent ?? 50.0;
      }
    });
    await Navigator.push(
        context,
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
                    customLeftOffset: widget.customLeftOffset,
                    customRightOffset: widget.customRightOffset,
                    menuItemsAlignment: widget.menuItemsAlignment ?? Alignment.center,
                    listViewBorderRadius: widget.listViewBorderRadius,
                    setmenuHeight: setmenuHeight,
                  ));
            },
            fullscreenDialog: true,
            opaque: false));
  }
}

class FocusedMenuDetails extends StatelessWidget {
  final List<FocusedMenuItem> menuItems;
  final BoxDecoration menuBoxDecoration;
  final Offset childOffset;
  final double itemExtent;
  final Size childSize;
  final Widget child;
  final bool animateMenu;
  final double blurSize;
  final double menuWidth;
  final Color blurBackgroundColor;
  final double bottomOffsetHeight;
  final double menuOffset;
  final double customLeftOffset;
  final double customRightOffset;
  final Alignment menuItemsAlignment;
  final BorderRadius listViewBorderRadius;
  final double setmenuHeight;

  const FocusedMenuDetails(
      {Key key,
      @required this.menuItems,
      @required this.child,
      @required this.childOffset,
      @required this.childSize,
      @required this.menuBoxDecoration,
      @required this.itemExtent,
      @required this.animateMenu,
      @required this.blurSize,
      @required this.blurBackgroundColor,
      @required this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset,
      this.customLeftOffset,
      this.customRightOffset,
      @required this.menuItemsAlignment,
      this.listViewBorderRadius,
      this.setmenuHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final maxMenuHeight = setmenuHeight;
    final listHeight = menuItems.length * (itemExtent ?? 50.0);

    final maxMenuWidth = menuWidth ?? (size.width * 0.70);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    final leftOffset = (childOffset.dx + maxMenuWidth) < size.width
        ? childOffset.dx
        : (childOffset.dx - maxMenuWidth + childSize.width);
    /*final topOffset = (childOffset.dy + menuHeight + childSize.height) <
            size.height - bottomOffsetHeight
        ? childOffset.dy + childSize.height + menuOffset
        : childOffset.dy - menuHeight - menuOffset;*/
        var childpos = size.height - childOffset.dy - childSize.height;
    final bottomOffset = childpos >
            (menuItems.where((element) => element != null).length *
                    (itemExtent ?? 50.0) - bottomOffsetHeight)
        ? childpos - (menuItems.where((element) => element != null).length *
                    (itemExtent ?? 50.0)) - bottomOffsetHeight
        : bottomOffsetHeight;
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
                      sigmaX: blurSize ?? 4, sigmaY: blurSize ?? 4),
                  child: Container(
                    color:
                        (blurBackgroundColor ?? Colors.black).withOpacity(0.7),
                  ),
                )),
            Positioned(
                bottom: bottomOffset,
                left: customLeftOffset ?? leftOffset,
                right: customRightOffset,
                child: Column(
                  children: [
                    AbsorbPointer(
                        absorbing: true,
                        child: Container(
                            width: childSize.width,
                            height: childSize.height,
                            child: child)),
                    Container(height: 10),
                    TweenAnimationBuilder(
                      duration: Duration(milliseconds: 200),
                      builder: (BuildContext context, value, Widget child) {
                        return Transform.scale(
                          scale: value,
                          alignment: menuItemsAlignment,
                          child: child,
                        );
                      },
                      tween: Tween(begin: 0.0, end: 1.0),
                      child: Container(
                        alignment: menuItemsAlignment,
                        width: maxMenuWidth,
                        decoration: menuBoxDecoration ??
                            BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
                                boxShadow: [
                                  const BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 10,
                                      spreadRadius: 1)
                                ]),
                        child: ClipRRect(
                          borderRadius: listViewBorderRadius ??
                              const BorderRadius.all(Radius.circular(5.0)),
                          child: ListView.builder(
                            itemCount: menuItems.length,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              FocusedMenuItem item = menuItems[index];
                              Widget listItem = item == null
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        item.onPressed();
                                      },
                                      child: Container(
                                          alignment: menuItemsAlignment,
                                          margin:
                                              const EdgeInsets.only(bottom: 1),
                                          color: item.backgroundColor ??
                                              Colors.white,
                                          height: itemExtent ?? 50.0,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 14),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                item.title,
                                                if (item.trailingIcon !=
                                                    null) ...[item.trailingIcon]
                                              ],
                                            ),
                                          )));
                              if (animateMenu) {
                                return TweenAnimationBuilder(
                                    builder: (context, value, child) {
                                      return Transform(
                                        transform:
                                            Matrix4.rotationX(1.5708 * value),
                                        alignment: Alignment.bottomCenter,
                                        child: child,
                                      );
                                    },
                                    tween: Tween(begin: 1.0, end: 0.0),
                                    duration:
                                        Duration(milliseconds: index * 200),
                                    child: listItem);
                              } else {
                                return listItem;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            /* Positioned(
                top: childOffset.dy,
                left: childOffset.dx,
                child: ),*/
          ],
        ),
      ),
    );
  }
}
