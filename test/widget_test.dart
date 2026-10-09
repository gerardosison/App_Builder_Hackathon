import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hawkabuild/features/auth/presentation/register_screen.dart';
import 'package:hawkabuild/features/auth/presentation/login_screen.dart';
import 'package:hawkabuild/features/onboarding/presentation/welcome_screen.dart';
import 'package:hawkabuild/features/onboarding/presentation/tour_screen.dart';
import 'package:hawkabuild/features/onboarding/presentation/personalization_screen.dart';
import 'package:hawkabuild/features/home/presentation/home_screen.dart';
import 'package:hawkabuild/app/app.dart';

void main() {
  testWidgets(
    'App opens on the login screen',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: PipSpeakApp()));
      await tester.pump();
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);
    },
  );

  testWidgets('Register Screen multi-step flow and indicators', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

    // Step 1: Enter first name and last name
    expect(find.text('Step 1 of 3'), findsWidgets);
    expect(find.text('Enter first name and last name'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'First name'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Last name'), findsOneWidget);

    // Fill Step 1
    await tester.enterText(
      find.widgetWithText(TextField, 'First name'),
      'Alex',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Last name'),
      'Morgan',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
    await tester.pumpAndSettle();

    // Step 2: Enter nickname
    expect(find.text('Step 2 of 3'), findsWidgets);
    expect(find.text('Enter nickname'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Nickname'), findsOneWidget);

    // Fill Step 2
    await tester.enterText(find.widgetWithText(TextField, 'Nickname'), 'Lexie');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
    await tester.pumpAndSettle();

    // Step 3: Enter username and password with indicators
    expect(find.text('Step 3 of 3'), findsWidgets);
    expect(find.text('Enter username and password'), findsOneWidget);
    expect(find.text('Username must be unique (min 3 chars)'), findsOneWidget);
    expect(
      find.textContaining('Password must be 8 min characters'),
      findsOneWidget,
    );

    // Test unique username indicator
    await tester.enterText(
      find.widgetWithText(TextField, 'Username'),
      'speaker',
    ); // taken
    await tester.pumpAndSettle();
    expect(
      find.text('Username is already taken - choose another'),
      findsOneWidget,
    );

    await tester.enterText(
      find.widgetWithText(TextField, 'Username'),
      'lexie_pro',
    ); // unique
    await tester.pumpAndSettle();
    expect(find.text('Username is unique and available!'), findsOneWidget);

    // Test password 8 min characters indicator
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'pass');
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Password must be 8 min characters (4/8)'),
      findsOneWidget,
    );

    await tester.enterText(
      find.widgetWithText(TextField, 'Password'),
      'password123',
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Password meets requirement (8+ min characters)'),
      findsOneWidget,
    );

    // Proceed to Welcome Screen
    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Proceed to Welcome Screen'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome, Lexie!'), findsOneWidget);
  });

  testWidgets(
    'Register Screen shows animated confirmation prompt when exiting',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

      // Tap Cancel button in AppBar
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Verify animated confirmation dialog contents
      expect(find.text('Cancel Registration?'), findsOneWidget);
      expect(find.text('Cancel registration'), findsOneWidget);
      expect(find.text('Continue registration'), findsOneWidget);

      // Choose Continue registration to dismiss and stay on screen
      await tester.tap(find.text('Continue registration'));
      await tester.pumpAndSettle();

      expect(find.text('Cancel Registration?'), findsNothing);
      expect(find.text('Step 1 of 3'), findsWidgets);
    },
  );

  testWidgets(
    'Welcome Screen introduces user, fades in journey text, and has Let’s go button',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: WelcomeScreen(nickname: 'Jordan')),
      );

      // Introduction
      expect(find.text('Welcome, Jordan!'), findsOneWidget);

      // Fade in text exists
      expect(
        find.text('Let’s begin your journey towards better speaking!'),
        findsOneWidget,
      );

      // Bottom: Let's go button
      expect(find.widgetWithText(ElevatedButton, 'Let’s go'), findsOneWidget);

      // Let's go navigates to TourScreen
      await tester.tap(find.widgetWithText(ElevatedButton, 'Let’s go'));
      await tester.pumpAndSettle();
      expect(find.byType(TourScreen), findsOneWidget);
    },
  );

  testWidgets(
    'Tour Screen previews main pages and shows tooltips about function & features',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TourScreen()));

      final pages = [
        'Home',
        'Practice',
        'Progress',
        'Profile',
        'Settings',
      ];

      for (int i = 0; i < pages.length; i++) {
        expect(find.text(pages[i]), findsWidgets);
        expect(find.text('FUNCTION:'), findsOneWidget);
        expect(find.text('KEY FEATURES:'), findsOneWidget);

        if (i < pages.length - 1) {
          await tester.tap(find.byType(ElevatedButton));
          await tester.pumpAndSettle();
        }
      }

      // On Settings page, clicking button navigates to PersonalizationScreen
      await tester.tap(
        find.widgetWithText(ElevatedButton, 'Personalize my journey'),
      );
      await tester.pumpAndSettle();
      expect(find.byType(PersonalizationScreen), findsOneWidget);
    },
  );

  testWidgets(
    'Personalization Screen collects language and practice purposes across pages',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PersonalizationScreen()));

      // Page 1: Select Language (with Flag Icon & Flag Name) - Dropdown
      expect(find.text('What language would you like to use?'), findsOneWidget);
      expect(find.text('SELECT LANGUAGE'), findsOneWidget);
      expect(find.text('English (US)'), findsWidgets);

      // Move to Page 2
      await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
      await tester.pumpAndSettle();

      // Page 2: What are you practicing for (select all that apply) - Dropdown
      expect(
        find.text('What are you practicing for? (Select all that apply)'),
        findsOneWidget,
      );
      expect(find.text('Public Speaking'), findsWidgets);
      expect(find.text('Recitation'), findsWidgets);
      expect(find.text('Presentation'), findsWidgets);
      expect(find.text('Debate'), findsWidgets);
      expect(find.text('Others'), findsWidgets);

      // Toggle options
      await tester.tap(find.text('Presentation'));
      await tester.pumpAndSettle();

      // Proceed to HomeScreen
      final proceedBtn = find.widgetWithText(
        ElevatedButton,
        'Build my personalized plan',
      );
      await tester.ensureVisible(proceedBtn);
      await tester.tap(proceedBtn);
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    },
  );

  testWidgets(
    'Home navigation exposes the primary app destinations',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: HomeScreen(location: '/home', child: Text('Home screen')),
      ));

      expect(find.byType(NavigationBar), findsNothing);
      for (final destination in [
        'Home',
        'Practice',
        'Documents',
        'Progress',
        'Profile',
      ]) {
        expect(find.text(destination), findsOneWidget);
      }
    },
  );
}
