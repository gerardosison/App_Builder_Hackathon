import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_builder_hackathon/app/app.dart';

void main() {
  testWidgets('HawkABuild App Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PipSpeakApp()));
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
