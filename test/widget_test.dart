import 'package:app_builder_hackathon/features/auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Login screen renders account fields', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(Scaffold), findsWidgets);
    expect(find.byType(TextField), findsAtLeastNWidgets(2));
  });
}
