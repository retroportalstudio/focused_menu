import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/src/widgets/focused_menu_widget.dart';

void main() {
  testWidgets('FocusedMenuDetails should render correctly',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      _HelperWidget(
        child: FocusedMenuHolder(
          menuItems: [
            FocusedMenuItem(
              title: const Text("Item"),
              onPressed: () {},
              trailing: const Icon(Icons.arrow_forward),
            )
          ],
          child: const Text('Tap me'),
        ),
      ),
    );

    // Act
    await tester.pump();
    await tester.longPress(find.text('Tap me'));
    await tester.pump();

    // Assert
    expect(find.byType(FocusedMenuDetails), findsOneWidget);
  });

  testWidgets('FocusedMenuWidget should be positioned correctly',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      _HelperWidget(
        child: FocusedMenuHolder(
          menuItems: [
            FocusedMenuItem(
              title: const Text("Item"),
              onPressed: () {},
              trailing: const Icon(Icons.arrow_forward),
            )
          ],
          child: const Text('Tap me'),
        ),
      ),
    );

    // Act
    await tester.pump();
    await tester.longPress(find.text('Tap me'));
    await tester.pump();

    // Assert
    expect(find.byType(FocusedMenuWidget), findsOneWidget);

    final RenderBox box = tester.renderObject(find.byType(FocusedMenuWidget));
    final Offset topLeftPositionOfMenuWidget = box.localToGlobal(Offset.zero);

    expect(topLeftPositionOfMenuWidget.dx, 0);
    expect(topLeftPositionOfMenuWidget.dy, 14);
  });

  testWidgets(
      'FocusedMenuWidget should be positioned correctly when setting menuOffset',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      _HelperWidget(
        child: FocusedMenuHolder(
          menuOffset: 10,
          menuItems: [
            FocusedMenuItem(
              title: const Text("Item"),
              onPressed: () {},
              trailing: const Icon(Icons.arrow_forward),
            )
          ],
          child: const Text('Tap me'),
        ),
      ),
    );

    // Act
    await tester.pump();
    await tester.longPress(find.text('Tap me'));
    await tester.pump();

    // Assert
    expect(find.byType(FocusedMenuWidget), findsOneWidget);

    final RenderBox box = tester.renderObject(find.byType(FocusedMenuWidget));
    final Offset topLeftPositionOfMenuWidget = box.localToGlobal(Offset.zero);

    expect(topLeftPositionOfMenuWidget.dx, 0);
    expect(topLeftPositionOfMenuWidget.dy, 24);
  });
}

class _HelperWidget extends StatelessWidget {
  final Widget child;
  const _HelperWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: child));
  }
}
