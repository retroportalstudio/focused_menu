import 'package:flutter/material.dart';
import 'package:focused_menu/src/models/models.dart';

final _defaultBoxDecoration = BoxDecoration(
  color: Colors.grey.shade200,
  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
  boxShadow: const [
    BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 1)
  ],
);

class FocusedMenuWidget extends StatelessWidget {
  const FocusedMenuWidget({
    Key? key,
    required this.topOffset,
    required this.leftOffset,
    required this.maxMenuWidth,
    required this.menuHeight,
    required this.menuBoxDecoration,
    required this.menuItems,
    required this.enableMenuScroll,
    required this.itemExtent,
    required this.animateMenu,
  }) : super(key: key);

  final double topOffset;
  final double leftOffset;
  final double maxMenuWidth;
  final double menuHeight;
  final BoxDecoration? menuBoxDecoration;
  final List<FocusedMenuItem> menuItems;
  final bool enableMenuScroll;
  final double? itemExtent;
  final bool animateMenu;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topOffset,
      left: leftOffset,
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 200),
        builder: (BuildContext context, double value, Widget? child) {
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
          decoration: menuBoxDecoration ?? _defaultBoxDecoration,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: ListView.builder(
              itemCount: menuItems.length,
              padding: EdgeInsets.zero,
              physics: enableMenuScroll
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
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
                    height: itemExtent ?? 50.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 14,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          item.title,
                          if (item.trailing != null) ...[item.trailing!]
                        ],
                      ),
                    ),
                  ),
                );
                if (animateMenu) {
                  return TweenAnimationBuilder(
                    builder: (context, double value, child) {
                      return Transform(
                        transform: Matrix4.rotationX(1.5708 * value),
                        alignment: Alignment.bottomCenter,
                        child: child,
                      );
                    },
                    tween: Tween(begin: 1.0, end: 0.0),
                    duration: Duration(milliseconds: index * 200),
                    child: listItem,
                  );
                } else {
                  return listItem;
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
