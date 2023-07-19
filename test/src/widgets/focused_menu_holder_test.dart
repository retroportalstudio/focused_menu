import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focused_menu/focused_menu.dart';

import '../../helpers/helpers.dart';

void main() {
  testWidgets('FocusedMenuDetails should open by calling the controller',
      (WidgetTester tester) async {
    // Arrange
    final controller = FocusedMenuHolderController();

    await tester.pumpWidget(
      HelperWidget(
        child: FocusedMenuHolder(
          controller: controller,
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
    controller.open();
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(FocusedMenuDetails), findsOneWidget);
  });
}
