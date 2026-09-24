import 'package:brew_coffee/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Brew Coffee app loads home', (tester) async {
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(BrewCoffeeApp());
    await tester.pumpAndSettle();
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    expect(find.text('START ORDERING'), findsOneWidget);
  });
}
