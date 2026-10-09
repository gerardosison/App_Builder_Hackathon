import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_builder_hackathon/main.dart';

void main() {
  testWidgets('HawkABuild App Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(const HawkABuildApp());
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
