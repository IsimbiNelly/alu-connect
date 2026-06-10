import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:alu_connect/main.dart';
import 'package:alu_connect/providers/event_provider.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => EventProvider(),
        child: const ALUConnectApp(),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
    // Advance past the 3-second splash screen timer so no pending timers remain
    await tester.pump(const Duration(seconds: 4));
    await tester.pump();
  });
}
