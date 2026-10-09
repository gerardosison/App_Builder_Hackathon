import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Personalization selections made during onboarding.
final selectedLanguageProvider = StateProvider<String>((_) => 'en-US');
final selectedGoalProvider = StateProvider<String>((_) => 'presentation');
