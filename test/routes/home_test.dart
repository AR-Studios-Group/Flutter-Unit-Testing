import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing/routes/home.dart';

void main() {
  testWidgets('Database Add Test', (tester) async {
    final addButton = find.byKey(ValueKey("add button"));

    await tester.pumpWidget(MaterialApp(home: Home()));

    await tester.tap(addButton);

    await tester.pump();

    expect(Home().dbController.reports.length, 1);
  });

  testWidgets('Database Read All Test', (tester) async {
    final addButton = find.byKey(ValueKey("add button"));
    final readButton = find.byKey(ValueKey("read all"));

    final homeWiget = Home();

    await tester.pumpWidget(MaterialApp(home: homeWiget));

    await tester.tap(addButton);
    await tester.tap(addButton);
    await tester.tap(addButton);

    await tester.tap(readButton);

    await tester.pump();

    expect(homeWiget.dbController.reports.length, 3);
  });
}
