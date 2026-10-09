import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hawkabuild/app/app.dart';

void main() {
  testWidgets('PipSpeak boots to the splash screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PipSpeakApp()));
    await tester.pump();
    expect(find.text('PipSpeak'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
  });
}
